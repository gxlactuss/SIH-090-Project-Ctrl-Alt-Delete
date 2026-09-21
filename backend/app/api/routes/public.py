"""Public share pages for published listings.

A buyer opening the link the artisan sent on WhatsApp has no account, so these
routes take no token. They answer only while a listing is published: before
that, and after it is taken down, every URL here is a plain 404.
"""
import uuid
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import FileResponse, HTMLResponse
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.listing import Listing
from app.models.media import Media
from app.schemas.enums import ListingState, MediaType
from app.services.media_storage import stored_media_file
from app.services.ondc.catalog import preview_item_for_listing
from app.services.ondc.preview import render_preview_html

router = APIRouter(prefix="/p", tags=["Share pages"])


def _published_listing(db: Session, listing_id: str) -> Listing:
    try:
        listing_uuid = uuid.UUID(listing_id)
    except (ValueError, TypeError):
        listing_uuid = None
    listing: Optional[Listing] = (
        db.query(Listing).filter(Listing.id == listing_uuid).first() if listing_uuid else None
    )
    if listing is None or listing.state != ListingState.published:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Listing not found.")
    return listing


@router.get(
    "/{listing_id}",
    response_class=HTMLResponse,
    summary="Listing Share Page",
    description="Read-only page for a published listing, as shared on WhatsApp.",
)
def listing_share_page(listing_id: str, db: Session = Depends(get_db)) -> HTMLResponse:
    listing = _published_listing(db, listing_id)
    attributes = (listing.result.attributes or {}) if listing.result else {}
    html = render_preview_html(
        preview_item_for_listing(listing),
        short_desc_hi=attributes.get("short_description_hi"),
        long_desc_hi=attributes.get("long_description_hi"),
    )
    return HTMLResponse(content=html)


@router.get(
    "/{listing_id}/images/{media_id}",
    summary="Listing Share Page Photo",
    description="A photo of a published listing, for its share page and ONDC catalog entry.",
    responses={200: {"content": {"image/jpeg": {}}, "description": "The photo."}},
)
def listing_share_image(listing_id: str, media_id: str, db: Session = Depends(get_db)) -> FileResponse:
    listing = _published_listing(db, listing_id)
    try:
        media_uuid = uuid.UUID(media_id)
    except (ValueError, TypeError):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Photo not found.")

    media = (
        db.query(Media)
        .filter(
            Media.id == media_uuid,
            Media.listing_id == listing.id,
            Media.media_type == MediaType.image,
        )
        .first()
    )
    found = stored_media_file(media) if media is not None else None
    if found is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Photo not found.")

    path, served_processed = found
    return FileResponse(
        path,
        media_type=("image/jpeg" if served_processed else media.mime_type) or "application/octet-stream",
    )
