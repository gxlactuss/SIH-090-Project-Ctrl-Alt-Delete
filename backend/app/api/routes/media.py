import uuid
from typing import Optional

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from app.core.security import get_current_seller
from app.db.session import get_db
from app.models.listing import Listing
from app.models.media import Media
from app.models.seller import Seller
from app.schemas.enums import MediaType
from app.schemas.media import MediaUploadResponse
from app.services.media_storage import delete_stored_file, save_media_upload

router = APIRouter(prefix="/listings", tags=["Media"])


@router.post(
    "/{listing_id}/media",
    response_model=MediaUploadResponse,
    status_code=status.HTTP_200_OK,
    summary="Upload Listing Media",
    description="Upload media (image or audio) associated with a listing using multipart/form-data.",
)
async def upload_listing_media(
    listing_id: str,
    file: UploadFile = File(...),
    media_type: MediaType = Form(...),
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> MediaUploadResponse:
    # 1. Validate and store media file on local disk
    stored = await save_media_upload(
        file=file,
        media_type=media_type,
        listing_id=listing_id,
    )

    # 2. Listing persistence seam (Task 6 boundary)
    # If the listing exists in the database, associate Media and check seller ownership.
    # If listing persistence is still stubbed (e.g. unpersisted id), preserve the stub seam.
    listing_uuid: Optional[uuid.UUID] = None
    try:
        listing_uuid = uuid.UUID(listing_id)
    except (ValueError, TypeError, AttributeError):
        pass

    if listing_uuid is not None:
        db_listing = db.query(Listing).filter(Listing.id == listing_uuid).first()
        if db_listing is not None:
            # Enforce seller ownership if listing exists in DB
            if db_listing.seller_id != current_seller.id:
                delete_stored_file(stored.dest_path)
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Listing does not belong to authenticated seller.",
                )

            # Persist Media metadata record
            media_record = Media(
                id=stored.media_id,
                listing_id=db_listing.id,
                media_type=media_type,
                original_filename=stored.original_filename,
                storage_path=stored.storage_path,
                mime_type=stored.mime_type,
                file_size_bytes=stored.file_size_bytes,
            )
            try:
                db.add(media_record)
                db.commit()
                db.refresh(media_record)
            except Exception as exc:
                db.rollback()
                delete_stored_file(stored.dest_path)
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to persist media metadata.",
                ) from exc

    return MediaUploadResponse(
        id=str(stored.media_id),
        listing_id=listing_id,
        media_type=media_type,
        status="uploaded",
    )
