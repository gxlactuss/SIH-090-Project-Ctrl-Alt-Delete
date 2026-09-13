from fastapi import APIRouter, File, Form, UploadFile, status
from app.schemas.enums import MediaType
from app.schemas.media import MediaUploadResponse

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
) -> MediaUploadResponse:
    # Contract stub: do not store file, simply return deterministic response
    return MediaUploadResponse(
        id=f"med-{media_type.value}-001",
        listing_id=listing_id,
        media_type=media_type,
        status="uploaded",
    )
