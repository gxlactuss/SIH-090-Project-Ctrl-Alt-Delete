from fastapi import APIRouter, status
from app.schemas.enums import ListingState
from app.schemas.listing import (
    ListingCreateRequest,
    ListingResponse,
    ListingListResponse,
    ListingStatusResponse,
    ListingAttentionResponse,
    ListingReadbackResponse,
)
from app.schemas.approval import ListingApprovalRequest, ListingApprovalResponse
from app.schemas.suggestion import (
    SuggestionItem,
    ListingSuggestionsResponse,
    SuggestionApprovalRequest,
    SuggestionApprovalResponse,
)
from app.schemas.consent import ListingConsentRequest, ListingConsentResponse
from app.schemas.preview import ListingPreviewResponse, ListingPublishResponse

router = APIRouter(prefix="/listings", tags=["Listings"])


@router.post(
    "",
    response_model=ListingResponse,
    status_code=status.HTTP_200_OK,
    summary="Create / Queue Listing",
    description="Create/queue a new listing item with a mobile client item identifier.",
)
def create_listing(payload: ListingCreateRequest) -> ListingResponse:
    return ListingResponse(
        id=f"lst-stub-{payload.client_item_id}",
        client_item_id=payload.client_item_id,
        state=ListingState.queued,
    )


@router.get(
    "",
    response_model=ListingListResponse,
    status_code=status.HTTP_200_OK,
    summary="List Seller Listings",
    description="Return listings belonging to the current seller.",
)
def list_listings() -> ListingListResponse:
    return ListingListResponse(
        items=[
            ListingResponse(
                id="lst-stub-001",
                client_item_id="client-item-001",
                state=ListingState.queued,
            ),
            ListingResponse(
                id="lst-stub-002",
                client_item_id="client-item-002",
                state=ListingState.ready,
            ),
        ]
    )


@router.get(
    "/{listing_id}",
    response_model=ListingResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing",
    description="Fetch a listing by its server identifier.",
)
def get_listing(listing_id: str) -> ListingResponse:
    return ListingResponse(
        id=listing_id,
        client_item_id="client-item-sample",
        state=ListingState.queued,
    )


@router.get(
    "/{listing_id}/status",
    response_model=ListingStatusResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Pipeline Status",
    description="Return current processing state of the listing in the pipeline.",
)
def get_listing_status(listing_id: str) -> ListingStatusResponse:
    return ListingStatusResponse(
        listing_id=listing_id,
        state=ListingState.queued,
    )


@router.get(
    "/{listing_id}/attention",
    response_model=ListingAttentionResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Attention Details",
    description="Return attention information when a listing requires artisan intervention.",
)
def get_listing_attention(listing_id: str) -> ListingAttentionResponse:
    return ListingAttentionResponse(
        listing_id=listing_id,
        needs_attention=False,
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
def get_listing_readback(listing_id: str) -> ListingReadbackResponse:
    return ListingReadbackResponse(
        listing_id=listing_id,
        language="hi",
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
def approve_listing(listing_id: str, payload: ListingApprovalRequest) -> ListingApprovalResponse:
    return ListingApprovalResponse(
        listing_id=listing_id,
        approved=payload.approved,
        state=ListingState.ready if payload.approved else ListingState.needs_attention,
    )


@router.get(
    "/{listing_id}/suggestions",
    response_model=ListingSuggestionsResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Suggested Additions",
    description="Return non-binding suggested additions for artisan review.",
)
def get_listing_suggestions(listing_id: str) -> ListingSuggestionsResponse:
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
) -> SuggestionApprovalResponse:
    return SuggestionApprovalResponse(
        listing_id=listing_id,
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
) -> ListingConsentResponse:
    return ListingConsentResponse(
        listing_id=listing_id,
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
def publish_listing(listing_id: str) -> ListingPublishResponse:
    return ListingPublishResponse(
        listing_id=listing_id,
        state=ListingState.published,
        preview_url=None,
    )


@router.get(
    "/{listing_id}/preview",
    response_model=ListingPreviewResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Listing Preview",
    description="Return read-only listing preview data.",
)
def get_listing_preview(listing_id: str) -> ListingPreviewResponse:
    return ListingPreviewResponse(
        listing_id=listing_id,
        title="Handcrafted Madhubani Painting",
        description="Traditional handmade Madhubani folk art painting on handmade paper.",
        price=None,
        image_urls=[],
    )
