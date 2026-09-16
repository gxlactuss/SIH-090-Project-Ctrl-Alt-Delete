from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.core.security import get_current_seller
from app.db.session import get_db
from app.models.seller import Seller
from app.schemas.approval import ListingApprovalRequest, ListingApprovalResponse
from app.schemas.consent import ListingConsentRequest, ListingConsentResponse
from app.schemas.enums import ListingState
from app.schemas.listing import (
    ListingAttentionResponse,
    ListingCreateRequest,
    ListingListResponse,
    ListingReadbackResponse,
    ListingResponse,
    ListingStatusResponse,
)
from app.schemas.preview import ListingPreviewResponse, ListingPublishResponse
from app.schemas.suggestion import (
    ListingSuggestionsResponse,
    SuggestionApprovalRequest,
    SuggestionApprovalResponse,
    SuggestionItem,
)
from app.services.listing import (
    create_or_get_listing,
    get_listing_for_seller,
    list_seller_listings,
    transition_listing,
)

router = APIRouter(prefix="/listings", tags=["Listings"])


@router.post(
    "",
    response_model=ListingResponse,
    status_code=status.HTTP_200_OK,
    summary="Create / Queue Listing",
    description="Create/queue a new listing item with a mobile client item identifier.",
)
def create_listing(
    payload: ListingCreateRequest,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingResponse:
    listing = create_or_get_listing(
        db=db,
        seller_id=current_seller.id,
        client_item_id=payload.client_item_id,
    )
    return ListingResponse(
        id=str(listing.id),
        client_item_id=listing.client_item_id,
        state=listing.state,
    )


@router.get(
    "",
    response_model=ListingListResponse,
    status_code=status.HTTP_200_OK,
    summary="List Seller Listings",
    description="Return listings belonging to the current seller.",
)
def list_listings(
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingListResponse:
    listings = list_seller_listings(db=db, seller_id=current_seller.id)
    return ListingListResponse(
        items=[
            ListingResponse(
                id=str(item.id),
                client_item_id=item.client_item_id,
                state=item.state,
            )
            for item in listings
        ]
    )


@router.get(
    "/{listing_id}",
    response_model=ListingResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing",
    description="Fetch a listing by its server identifier.",
)
def get_listing(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingResponse(
        id=str(listing.id),
        client_item_id=listing.client_item_id,
        state=listing.state,
    )


@router.get(
    "/{listing_id}/status",
    response_model=ListingStatusResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Pipeline Status",
    description="Return current processing state of the listing in the pipeline.",
)
def get_listing_status(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingStatusResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingStatusResponse(
        listing_id=str(listing.id),
        state=listing.state,
    )


@router.get(
    "/{listing_id}/attention",
    response_model=ListingAttentionResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Attention Details",
    description="Return attention information when a listing requires artisan intervention.",
)
def get_listing_attention(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingAttentionResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingAttentionResponse(
        listing_id=str(listing.id),
        needs_attention=(listing.state == ListingState.needs_attention),
        question=None,
        field=None,
    )


@router.get(
    "/{listing_id}/readback",
    response_model=ListingReadbackResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Read-back Details",
    description="Return generated listing information for artisan review and audio read-back.",
)
def get_listing_readback(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingReadbackResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingReadbackResponse(
        listing_id=str(listing.id),
        language=current_seller.language or "hi",
        title="Handcrafted Madhubani Painting",
        description="Traditional handmade Madhubani folk art painting on handmade paper.",
        price=None,
        audio_url=None,
    )


@router.post(
    "/{listing_id}/approval",
    response_model=ListingApprovalResponse,
    status_code=status.HTTP_200_OK,
    summary="Submit Listing Approval",
    description="Record artisan review approval/correction for generated listing data.",
)
def approve_listing(
    listing_id: str,
    payload: ListingApprovalRequest,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingApprovalResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    target_state = ListingState.ready if payload.approved else ListingState.needs_attention
    listing = transition_listing(db=db, listing=listing, new_state=target_state)
    return ListingApprovalResponse(
        listing_id=str(listing.id),
        approved=payload.approved,
        state=listing.state,
    )


@router.get(
    "/{listing_id}/suggestions",
    response_model=ListingSuggestionsResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Suggested Additions",
    description="Return non-binding suggested additions for artisan review.",
)
def get_listing_suggestions(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingSuggestionsResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingSuggestionsResponse(
        items=[
            SuggestionItem(
                id="sug-001",
                field="material",
                value="Natural pigments and organic dyes",
                reason="Commonly associated with traditional Madhubani craft",
            )
        ]
    )


@router.post(
    "/{listing_id}/suggestions/{suggestion_id}/approval",
    response_model=SuggestionApprovalResponse,
    status_code=status.HTTP_200_OK,
    summary="Approve or Reject Suggestion",
    description="Explicitly approve or reject an individual suggested addition.",
)
def approve_suggestion(
    listing_id: str,
    suggestion_id: str,
    payload: SuggestionApprovalRequest,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> SuggestionApprovalResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return SuggestionApprovalResponse(
        listing_id=str(listing.id),
        suggestion_id=suggestion_id,
        approved=payload.approved,
    )


@router.post(
    "/{listing_id}/consent",
    response_model=ListingConsentResponse,
    status_code=status.HTTP_200_OK,
    summary="Record Artisan Consent",
    description="Record explicit permission to publish the artisan's photo and story.",
)
def record_listing_consent(
    listing_id: str,
    payload: ListingConsentRequest,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingConsentResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingConsentResponse(
        listing_id=str(listing.id),
        photo=payload.photo,
        story=payload.story,
        ready_to_publish=payload.photo and payload.story,
    )


@router.post(
    "/{listing_id}/publish",
    response_model=ListingPublishResponse,
    status_code=status.HTTP_200_OK,
    summary="Publish Listing",
    description="Trigger publication after approval and consent stages have completed.",
)
def publish_listing(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingPublishResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    listing = transition_listing(db=db, listing=listing, new_state=ListingState.published)
    return ListingPublishResponse(
        listing_id=str(listing.id),
        state=listing.state,
        preview_url=None,
    )


@router.get(
    "/{listing_id}/preview",
    response_model=ListingPreviewResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Preview",
    description="Return read-only listing preview data.",
)
def get_listing_preview(
    listing_id: str,
    current_seller: Seller = Depends(get_current_seller),
    db: Session = Depends(get_db),
) -> ListingPreviewResponse:
    listing = get_listing_for_seller(db=db, listing_id=listing_id, seller_id=current_seller.id)
    return ListingPreviewResponse(
        listing_id=str(listing.id),
        title="Handcrafted Madhubani Painting",
        description="Traditional handmade Madhubani folk art painting on handmade paper.",
        price=None,
        image_urls=[],
    )
