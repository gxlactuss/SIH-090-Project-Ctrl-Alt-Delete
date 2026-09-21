"""Publishing a listing's fact sheet to the ONDC catalog.

The pipeline stores what it understood in a ListingResult. This turns that
row back into the language layer's FactSheet, maps it to an ONDC Item with
mapper.py, validates it against the ONDC schema, and lets lifecycle.py decide
whether the adapter should publish, republish or delist it. Every push is also
appended to the CSV backup.

The outcome is recorded on the listing's result under attributes["ondc"], so
publishing in the app never waits on, or fails because of, the ONDC side.
"""
import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.listing import Listing
from app.services.factsheet.confidence import run_confidence_check
from app.services.factsheet.schema import FactSheet, normalize_category
from app.services.listing_view import listing_description, public_image_urls
from app.services.ondc.adapter import MockOndcAdapter, OndcAdapter, RealOndcAdapter
from app.services.ondc.csv_export import export_single_item_to_csv
from app.services.ondc.lifecycle import ListingState as OndcListingState
from app.services.ondc.lifecycle import apply_lifecycle_action, decide_action
from app.services.ondc.mapper import get_domain_for_item, map_to_ondc_item, validate_item

logger = logging.getLogger("app.services.ondc.catalog")


class OndcNotReady(ValueError):
    """The listing lacks something ONDC requires. The message says what."""


def _rupees(paise: Optional[int]) -> Optional[float]:
    return round(paise / 100, 2) if paise is not None else None


def fact_sheet_for_listing(listing: Listing) -> FactSheet:
    """The listing as it stands now, artisan corrections included."""
    result = listing.result
    if result is None:
        return FactSheet(item_id=str(listing.id))
    attributes: Dict[str, Any] = result.attributes or {}

    price = result.price_in_paise
    if price is None:
        price = result.suggested_price_in_paise

    long_description = listing_description(listing)
    return FactSheet(
        item_id=str(listing.id),
        product_name=result.title,
        short_description=attributes.get("short_description") or result.title,
        long_description=long_description,
        short_description_hi=attributes.get("short_description_hi"),
        long_description_hi=attributes.get("long_description_hi"),
        category=normalize_category(attributes.get("category")),
        materials=result.material,
        dimensions=result.size,
        color=result.colour,
        technique=result.technique,
        origin=result.origin,
        cost_of_materials=_rupees(result.material_cost_in_paise),
        hours_spent=result.hours_to_make,
        price_final=_rupees(price),
        stock_count=result.quantity,
        returnable=attributes.get("returnable"),
    )


def _mapper_input(sheet: FactSheet) -> Dict[str, Any]:
    # The mapper reads optional keys with dict.get(key, default), so a key
    # present with None would override the default and print "None" as the MRP.
    return {k: v for k, v in sheet.model_dump().items() if v is not None}


def item_for_listing(listing: Listing) -> Tuple[Dict[str, Any], str]:
    """The listing as a validated ONDC Item, and the domain it belongs to."""
    sheet = run_confidence_check(fact_sheet_for_listing(listing))
    if not sheet.ready_to_publish:
        raise OndcNotReady("Missing required fields: " + ", ".join(sheet.missing_fields))
    if not sheet.long_description:
        raise OndcNotReady("Missing required fields: long_description")

    images = public_image_urls(listing)
    if not images:
        raise OndcNotReady("An ONDC item needs at least one photo")

    fields = _mapper_input(sheet)
    try:
        item = map_to_ondc_item(fields, images, images[0])
        domain = get_domain_for_item(fields)
    except ValueError as exc:
        raise OndcNotReady(str(exc)) from exc

    errors = validate_item(item)
    if errors:
        raise OndcNotReady("ONDC schema errors: " + "; ".join(errors))
    return item, domain


def preview_item_for_listing(listing: Listing) -> Dict[str, Any]:
    """An Item-shaped dict for the share page, even when ONDC would refuse it.

    The share page is for any published listing. One ONDC cannot take yet (no
    category, say) is still worth showing to a buyer on WhatsApp.
    """
    try:
        return item_for_listing(listing)[0]
    except OndcNotReady:
        pass

    sheet = fact_sheet_for_listing(listing)
    images = public_image_urls(listing)
    price = sheet.price_final
    return {
        "id": str(listing.id),
        "descriptor": {
            "name": sheet.product_name or "",
            "symbol": images[0] if images else "",
            "short_desc": sheet.short_description or "",
            "long_desc": sheet.long_description or "",
            "images": images,
        },
        "price": {
            "currency": "INR",
            "value": f"{price:g}" if price is not None else "",
            "maximum_value": f"{price:g}" if price is not None else "",
        },
        "category_id": "",
        "quantity": {"available": {"count": str(sheet.stock_count or 0)}},
        "@ondc/org/returnable": bool(sheet.returnable),
        "@ondc/org/cancellable": True,
        "@ondc/org/available_on_cod": True,
    }


def get_adapter() -> OndcAdapter:
    if (settings.ONDC_ADAPTER or "mock").lower() == "real":
        return RealOndcAdapter(settings.ONDC_API_BASE_URL or "", settings.ONDC_API_KEY or "")
    return MockOndcAdapter()


def export_path() -> Path:
    if settings.ONDC_EXPORT_CSV:
        return Path(settings.ONDC_EXPORT_CSV)
    return Path(settings.MEDIA_STORAGE_DIR) / "exports" / "ondc_listings.csv"


def _previous_state(record: Optional[Dict[str, Any]]) -> Optional[OndcListingState]:
    if not record or not isinstance(record.get("item"), dict):
        return None
    try:
        return OndcListingState(record["item"], is_published=record.get("status") == "published")
    except (KeyError, TypeError, ValueError):
        return None


def _now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def sync_listing(db: Session, listing: Listing, adapter: Optional[OndcAdapter] = None) -> Dict[str, Any]:
    """Bring the ONDC catalog in line with the listing and record the outcome.

    Called when the artisan publishes, and again whenever a published listing's
    facts change, so a price edit republishes and zero stock delists.
    """
    result = listing.result
    if result is None:
        return {"status": "not_ready", "reason": "The listing has not been processed yet."}

    attributes: Dict[str, Any] = dict(result.attributes or {})
    previous = attributes.get("ondc") if isinstance(attributes.get("ondc"), dict) else None

    try:
        item, domain = item_for_listing(listing)
    except OndcNotReady as exc:
        # Whatever was pushed before stays as it was; only the reason is new.
        record: Dict[str, Any] = {**(previous or {}), "reason": str(exc), "checked_at": _now()}
        record.setdefault("status", "not_ready")
        logger.info("Listing %s -> not sent to ONDC: %s", listing.id, exc)
        return _save(db, result, attributes, record)

    adapter = adapter or get_adapter()
    old_state = _previous_state(previous)
    new_state = OndcListingState(item, is_published=True)
    action = decide_action(old_state, new_state)

    record = dict(previous or {})
    record.update({"domain": domain, "item": item, "action": action, "checked_at": _now()})
    record.pop("reason", None)

    try:
        response = apply_lifecycle_action(adapter, action, item)
    except Exception as exc:
        logger.warning("Listing %s -> ONDC %s failed: %s", listing.id, action, exc)
        record.update({"status": "failed", "reason": f"ONDC {action} failed: {exc}"})
        return _save(db, result, attributes, record)

    if action in ("publish", "republish") and response:
        record.update(
            {
                "status": "published",
                "catalog_id": response.get("catalog_id"),
                "message": response.get("message"),
                "pushed_at": response.get("pushed_at") or _now(),
            }
        )
        _backup(item)
    elif action == "delist":
        record.update({"status": "delisted", "message": (response or {}).get("message")})
    elif not record.get("status"):
        record["status"] = "not_published"

    logger.info("Listing %s -> ONDC %s (%s)", listing.id, action, record.get("status"))
    return _save(db, result, attributes, record)


def _backup(item: Dict[str, Any]) -> None:
    path = export_path()
    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        export_single_item_to_csv(item, str(path))
    except OSError as exc:
        logger.warning("Could not append ONDC item %s to %s: %s", item.get("id"), path, exc)


def _save(db: Session, result, attributes: Dict[str, Any], record: Dict[str, Any]) -> Dict[str, Any]:
    # Reassigned rather than mutated in place so SQLAlchemy sees the JSON change.
    attributes["ondc"] = record
    result.attributes = attributes
    db.add(result)
    db.commit()
    return record

