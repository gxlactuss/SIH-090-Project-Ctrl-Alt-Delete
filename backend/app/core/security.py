"""Application JWT management and authenticated seller FastAPI dependency."""
import uuid
from datetime import datetime, timedelta, timezone
from typing import Any, Dict, Optional, Union

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import get_db
from app.models.seller import Seller

# auto_error=False so a missing header reaches get_current_seller, which
# either serves the demo seller or raises the same 401 HTTPBearer would have.
bearer_scheme = HTTPBearer(auto_error=False)


def create_access_token(
    seller_id: Union[str, uuid.UUID],
    expires_delta: Optional[timedelta] = None,
) -> str:
    """Create a signed application JWT identifying a persistent Seller entity."""
    now = datetime.now(timezone.utc)
    if expires_delta:
        expire = now + expires_delta
    else:
        expire = now + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    payload = {
        "sub": str(seller_id),
        "iat": int(now.timestamp()),
        "exp": int(expire.timestamp()),
    }
    encoded_jwt = jwt.encode(
        payload,
        settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM,
    )
    return encoded_jwt


def decode_access_token(token: str) -> Dict[str, Any]:
    """Decode and cryptographically validate an application JWT.

    Raises:
        HTTPException(401): If the token is invalid, expired, or malformed.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET,
            algorithms=[settings.JWT_ALGORITHM],
        )
        return payload
    except (jwt.ExpiredSignatureError, jwt.InvalidTokenError):
        raise credentials_exception


def _demo_seller(db: Session) -> Seller:
    """The single shared seller behind the public demo site.

    Created on first use rather than by a migration, so the demo deployment
    needs no seed step and a wiped database heals itself on the next request.
    """
    seller_id = uuid.UUID(settings.DEMO_SELLER_ID)

    seller = db.query(Seller).filter(Seller.id == seller_id).first()
    if seller is not None:
        return seller

    seller = Seller(id=seller_id, name=settings.DEMO_SELLER_NAME, language="en")
    db.add(seller)
    try:
        db.commit()
    except IntegrityError:
        # Two first requests raced each other. The other one won; take its row.
        db.rollback()
        seller = db.query(Seller).filter(Seller.id == seller_id).first()
        if seller is None:
            raise
        return seller

    db.refresh(seller)
    return seller


def get_current_seller(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> Seller:
    """FastAPI security dependency for extracting and resolving the current authenticated seller."""
    if credentials is None:
        if settings.DEMO_MODE:
            return _demo_seller(db)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # A token that is present but bad is still rejected, demo mode or not.
    token = credentials.credentials
    payload = decode_access_token(token)

    seller_id_str = payload.get("sub")
    if not seller_id_str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        seller_uuid = uuid.UUID(seller_id_str)
    except (ValueError, TypeError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid subject identifier in token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    seller = db.query(Seller).filter(Seller.id == seller_uuid).first()
    if seller is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Seller not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return seller
