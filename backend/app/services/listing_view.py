"""Build the listing payload the mobile app consumes.

One place decides how a stored pipeline result becomes a response, so the
list endpoint, the detail endpoint and every action that returns a listing all
answer with the same shape.
"""
from pathlib import Path
from typing import List, Optional

from app.core.config import settings
from app.models.listing import Listing
from app.models.media import Media
from app.models.suggestion import Suggestion
from app.schemas.enums import ListingState, MediaType
from app.schemas.listing import (
    FactSheetResponse,
    ListingResponse,
    SuggestionResponse,
)


def _media_version(media: Media) -> Optional[int]:
    """A marker that changes when the bytes behind a photo's URL change.

    A listing is read once while the pipeline is still running and again when it
    is ready, and both reads return the same URL for a photo even though the
    second one now serves the Vision Station's composite instead of the raw
    frame. The app caches images by URL, so without something to tell the two
    apart it would go on showing the camera frame it had already downloaded and
    the studio image would never appear. The processed file's modification time
    is the honest answer: it moves whenever a run rewrites the composite, and a
    re-run overwrites it in place under the same name.
    """
    if not media.processed_path:
        return None
    base_dir = Path(settings.MEDIA_STORAGE_DIR).resolve()
    try:
        path = (base_dir / media.processed_path).resolve()
        if not path.is_relative_to(base_dir):
            return None
        return int(path.stat().st_mtime)
    except (OSError, ValueError):
        return None


# Suggestion rows whose field starts with this are optional additions the
# language layer offered, rather than gaps the voice note left.
ADDITION_PREFIX = "addition"


def is_addition(suggestion: Suggestion) -> bool:
    return (suggestion.field or "").startswith(ADDITION_PREFIX)


def listing_images(listing: Listing) -> List[Media]:
    """This listing's photos, newest upload last."""
    images = [m for m in listing.media if m.media_type == MediaType.image]
    images.sort(key=lambda m: m.created_at or m.id)
    return images


def _versioned(url: str, media: Media) -> str:
    version = _media_version(media)
    return f"{url}?v={version}" if version is not None else url


def listing_image_urls(listing: Listing) -> List[str]:
    """Served URLs for this listing's photos, newest upload last."""
    return [
        _versioned(f"/api/v1/listings/{listing.id}/media/{m.id}", m)
        for m in listing_images(listing)
    ]


def public_url(path: str) -> str:
    """`path` on the address buyers reach, or root-relative when none is set."""
    base = (settings.PUBLIC_BASE_URL or "").strip().rstrip("/")
    return f"{base}{path}"


def public_image_urls(listing: Listing) -> List[str]:
    """Photo URLs anyone can open, for the share page and the ONDC catalog.

    They only answer while the listing is published.
    """
    return [
        public_url(_versioned(f"/p/{listing.id}/images/{m.id}", m))
        for m in listing_images(listing)
    ]


def preview_url_for(listing: Listing) -> Optional[str]:
    """The share page the app sends on WhatsApp and shows as a QR code."""
    if listing.state != ListingState.published:
        return None
    return public_url(f"/p/{listing.id}")


def listing_description(listing: Listing) -> Optional[str]:
    """The written description plus every addition the artisan said yes to.

    An addition the artisan skipped, or has not answered yet, never appears.
    """
    result = listing.result
    base = (result.description or "").strip() if result else ""
    extras = [
        s.value.strip()
        for s in listing.suggestions
        if is_addition(s) and s.approved is True and (s.value or "").strip()
    ]
    text = " ".join(part for part in [base, *extras] if part)
    return text or None


def _spoken_prompt(field: str, reason: Optional[str]) -> str:
    return reason or f"Shall I add the {field}?"


def _suggestion_response(s: Suggestion) -> SuggestionResponse:
    if is_addition(s):
        # A yes/no offer: the app reads the question aloud and, on yes, the
        # sentence joins the description.
        return SuggestionResponse(
            id=str(s.id),
            field=ADDITION_PREFIX,
            spoken_prompt=s.reason or s.value,
            text_if_accepted=s.value,
            approved=s.approved,
        )
    return SuggestionResponse(
        id=str(s.id),
        # _PROMPTS keys the pipeline's own name for the gap ("dimensions",
        # "colors") but stores the fact sheet field name ("size", "colour")
        # in `value`, and that is the name the app's input is keyed by.
        field=s.value or s.field,
        spoken_prompt=_spoken_prompt(s.value, s.reason),
        text_if_accepted=s.value,
        approved=s.approved,
    )


def to_listing_response(listing: Listing) -> ListingResponse:
    """A listing plus whatever the pipeline has understood about it so far."""
    result = listing.result
    consent = listing.consent

    fact_sheet = FactSheetResponse()
    if result is not None:
        fact_sheet = FactSheetResponse(
            material=result.material,
            size=result.size,
            colour=result.colour,
            quantity=result.quantity,
            price_in_paise=result.price_in_paise,
            hours_to_make=result.hours_to_make,
            material_cost_in_paise=result.material_cost_in_paise,
            is_one_of_a_kind=bool(result.is_one_of_a_kind),
        )

    return ListingResponse(
        id=str(listing.id),
        client_item_id=listing.client_item_id,
        state=listing.state,
        title=result.title if result else None,
        description=listing_description(listing),
        image_urls=listing_image_urls(listing),
        fact_sheet=fact_sheet,
        suggestions=[_suggestion_response(s) for s in listing.suggestions],
        follow_up_question=result.follow_up_question if result else None,
        suggested_price_in_paise=result.suggested_price_in_paise if result else None,
        price_floor_in_paise=result.price_floor_in_paise if result else None,
        preview_url=preview_url_for(listing),
        photo_consent=bool(consent.photo_consent) if consent else False,
        story_consent=bool(consent.story_consent) if consent else False,
        views=0,
        used_live_model=bool(result.used_live_model) if result else False,
    )
