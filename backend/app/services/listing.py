"""Listing service managing persistence, ownership verification, and state machine transitions."""
import uuid
from datetime import datetime, timezone
from typing import Dict, List, Set

from fastapi import HTTPException, status
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.models.listing import Listing
from app.schemas.enums import ListingState

# Explicit state transition graph
# queued -> processing -> (needs_attention | ready) -> published
VALID_STATE_TRANSITIONS: Dict[ListingState, Set[ListingState]] = {
    ListingState.queued: {ListingState.processing},
    ListingState.processing: {ListingState.needs_attention, ListingState.ready},
    ListingState.needs_attention: {ListingState.processing, ListingState.ready},
    ListingState.ready: {ListingState.published, ListingState.needs_attention},
    ListingState.published: set(),  # Terminal state
}


class ListingNotFoundError(HTTPException):
    """Raised when a listing is not found or does not belong to the requesting seller."""

    def __init__(self, detail: str = "Listing not found"):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail=detail)


class InvalidStateTransitionError(HTTPException):
    """Raised when an invalid state transition is attempted."""

    def __init__(self, current_state: ListingState, target_state: ListingState):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid state transition from '{current_state.value}' to '{target_state.value}'.",
        )


def parse_listing_uuid(listing_id: str) -> uuid.UUID:
    """Parse string listing_id into UUID, raising 404 if invalid."""
    try:
        return uuid.UUID(listing_id)
    except (ValueError, TypeError, AttributeError):
        raise ListingNotFoundError()


def get_listing_for_seller(db: Session, listing_id: str, seller_id: uuid.UUID) -> Listing:
    """Fetch a listing by ID, strictly verifying that it belongs to the authenticated seller.

    Raises:
        ListingNotFoundError (404): If the listing does not exist or belongs to another seller.
    """
    listing_uuid = parse_listing_uuid(listing_id)
    listing = db.query(Listing).filter(Listing.id == listing_uuid).first()
    if listing is None or listing.seller_id != seller_id:
        raise ListingNotFoundError()
    return listing


def create_or_get_listing(db: Session, seller_id: uuid.UUID, client_item_id: str) -> Listing:
    """Create a new listing in 'queued' state for the authenticated seller.

    If a listing with (seller_id, client_item_id) already exists, returns the existing listing
    deterministically (idempotent creation).
    """
    existing = db.query(Listing).filter(
        Listing.seller_id == seller_id,
        Listing.client_item_id == client_item_id,
    ).first()
    if existing is not None:
        return existing

    listing = Listing(
        seller_id=seller_id,
        client_item_id=client_item_id,
        state=ListingState.queued,
    )
    try:
        db.add(listing)
        db.commit()
        db.refresh(listing)
        return listing
    except IntegrityError:
        db.rollback()
        existing = db.query(Listing).filter(
            Listing.seller_id == seller_id,
            Listing.client_item_id == client_item_id,
        ).first()
        if existing is not None:
            return existing
        raise


def list_seller_listings(db: Session, seller_id: uuid.UUID) -> List[Listing]:
    """Retrieve all listings belonging to the authenticated seller, ordered newest first."""
    return (
        db.query(Listing)
        .filter(Listing.seller_id == seller_id)
        .order_by(Listing.created_at.desc())
        .all()
    )


def validate_state_transition(current_state: ListingState, target_state: ListingState) -> None:
    """Validate that transition from current_state to target_state is permitted.

    Self-transitions (target_state == current_state) are idempotent and permitted.
    """
    if current_state == target_state:
        return
    allowed_next = VALID_STATE_TRANSITIONS.get(current_state, set())
    if target_state not in allowed_next:
        raise InvalidStateTransitionError(current_state=current_state, target_state=target_state)


def transition_listing(db: Session, listing: Listing, new_state: ListingState) -> Listing:
    """Validate and execute a state transition on a listing, updating the updated_at timestamp."""
    validate_state_transition(listing.state, new_state)
    if listing.state != new_state:
        listing.state = new_state
        listing.updated_at = datetime.now(timezone.utc)
        db.commit()
        db.refresh(listing)
    return listing
