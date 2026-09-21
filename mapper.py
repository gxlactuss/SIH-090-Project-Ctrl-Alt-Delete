"""
mapper.py — Fact Sheet -> ONDC Item mapper
Publishing to ONDC module (Shivam)

NOTE: field names on the fact_sheet side are placeholders based on the
draft mapping table. Update once the real Pydantic model from
Ayush Shivdikar's fact-sheet module is available.
"""

import json
import uuid
from jsonschema import Draft7Validator, RefResolver

# ---- Load ONDC schema once ----
with open("ondc_schema.json") as f:
    ONDC_SCHEMA = json.load(f)

# NOTE: this schema file's Category.id enum is overly narrow — it only lists
# ['Grocery', 'Packaged Commodities', 'Packaged Foods', 'Fruits and Vegetables',
# 'F&B', 'Fashion'], but the REAL ONDC API contract (confirmed 18 Sept 2026
# from official docs) shows category_id values like "T Shirts" and "Home
# Furnishing - Bedding and Linen" — free-text values validated against the
# separate "Category taxonomy_v1.2" spreadsheet, not this hardcoded enum.
# We strip the enum here so validation reflects real ONDC behavior instead
# of this file's stale/narrow constraint.
try:
    ONDC_SCHEMA["components"]["schemas"]["Category"]["properties"]["id"].pop("enum", None)
except KeyError:
    pass  # schema structure differs — nothing to strip, validation proceeds as-is

ITEM_SCHEMA = ONDC_SCHEMA["components"]["schemas"]["Item"]
RESOLVER = RefResolver.from_schema(ONDC_SCHEMA)
VALIDATOR = Draft7Validator(ITEM_SCHEMA, resolver=RESOLVER)

# ---- Required fields per the Item schema (manually encoded, since $ref
# siblings in the schema aren't auto-enforced by jsonschema — see notes) ----
REQUIRED_DESCRIPTOR_FIELDS = ["name", "symbol", "short_desc", "long_desc", "images"]
REQUIRED_PRICE_FIELDS = ["value", "maximum_value", "currency"]

# category lookup — internal category string -> (ONDC domain, category_id)
# Sourced from the real ONDC "Category taxonomy_v1.2" sheet (Fashion RET12
# and Home & Kitchen RET16 tabs) confirmed 18 Sept 2026. Expand as the team
# adds more product types.
CATEGORY_MAP = {
    "textile":   ("ONDC:RET12", "Ethnic Wear"),
    "saree":     ("ONDC:RET12", "Sarees"),
    "kurta":     ("ONDC:RET12", "Kurtis, Tunics"),
    "scarf":     ("ONDC:RET12", "Dupattas & Shawls"),
    "fabric":    ("ONDC:RET12", "Unstitched Fabrics"),
    "jewellery": ("ONDC:RET12", "Ethnic Wear"),   # TODO: confirm a jewellery-
                                                    # specific category_id — the
                                                    # Fashion sheet has more rows
                                                    # further down we haven't
                                                    # checked yet
    "apparel":   ("ONDC:RET12", "Ethnic Wear"),
    "pottery":   ("ONDC:RET16", "Home Decor"),
    "woodwork":  ("ONDC:RET16", "Home Decor"),
    "basket":    ("ONDC:RET16", "Kitchen Storage and Containers"),
}


def map_to_ondc_item(fact_sheet: dict, image_urls: list[str], thumbnail_url: str) -> dict:
    """
    Convert an internal fact sheet dict into an ONDC-shaped Item dict.
    Raises ValueError if a required field is missing or still None
    (e.g. the fact-sheet pipeline hasn't finished / confidence check
    hasn't passed yet) before we even attempt schema validation.

    NOTE: this returns only the Item object. The ONDC "domain" (e.g.
    "ONDC:RET12" for Fashion, "ONDC:RET16" for Home & Kitchen) is a
    separate field that belongs in the outer API request's context
    object, not inside the Item itself. Use get_domain_for_item()
    below to get the matching domain string for whoever builds that
    context (likely Ayush Singh's pipeline runner).
    """

    if fact_sheet.get("price_final") is None:
        raise ValueError("Cannot map to ONDC item: price_final is not set yet "
                          "(fact sheet isn't ready_to_publish).")
    if fact_sheet.get("stock_count") is None:
        raise ValueError("Cannot map to ONDC item: stock_count is not set yet "
                          "(fact sheet isn't ready_to_publish).")

    category_lookup = CATEGORY_MAP.get(fact_sheet.get("category", "").lower())
    if category_lookup is None:
        raise ValueError(f"Unknown/unmapped category: {fact_sheet.get('category')}")
    domain, category = category_lookup

    item = {
        "id": fact_sheet.get("item_id") or str(uuid.uuid4()),
        "descriptor": {
            "name": fact_sheet["product_name"],
            "symbol": thumbnail_url,
            "short_desc": fact_sheet["short_description"],
            "long_desc": fact_sheet["long_description"],
            "images": image_urls,
        },
        "price": {
            "currency": "INR",
            "value": str(fact_sheet["price_final"]),
            "maximum_value": str(
    fact_sheet["price_mrp"]
    if fact_sheet.get("price_mrp") is not None
    else fact_sheet["price_final"]),
        },
        "category_id": category,
        "quantity": {
            "available": {"count": str(fact_sheet["stock_count"])},
            "maximum": {
    "count": str(
        fact_sheet["stock_max"]
        if fact_sheet.get("stock_max") is not None
        else fact_sheet["stock_count"]
    )
},
        },
        "@ondc/org/cancellable": True,            # TODO: confirm default with team
        "@ondc/org/available_on_cod": True,       # TODO: confirm default with team
        "@ondc/org/time_to_ship": "PT48H",        # TODO: confirm default with team
    }

    # Returnable is a per-seller/per-item choice, not a fixed default.
    # Expects fact_sheet["returnable"] = True/False, and if True,
    # fact_sheet["return_window"] as an ISO8601 duration string (e.g. "PT168H" for 7 days).
    is_returnable = bool(fact_sheet.get("returnable", False))
    item["@ondc/org/returnable"] = is_returnable
    if is_returnable:
        item["@ondc/org/return_window"] = fact_sheet.get("return_window", "PT168H")

    _check_required_fields(item)
    return item


def get_domain_for_item(fact_sheet: dict) -> str:
    """
    Returns the ONDC domain string (e.g. "ONDC:RET12") for a fact sheet's
    category. This is separate from the Item itself — it belongs in the
    outer API request context, not the item payload.
    """
    category_lookup = CATEGORY_MAP.get(fact_sheet.get("category", "").lower())
    if category_lookup is None:
        raise ValueError(f"Unknown/unmapped category: {fact_sheet.get('category')}")
    domain, _ = category_lookup
    return domain


def _check_required_fields(item: dict):
    missing = [f for f in REQUIRED_DESCRIPTOR_FIELDS if not item["descriptor"].get(f)]
    if missing:
        raise ValueError(f"Missing required descriptor fields: {missing}")

    missing = [f for f in REQUIRED_PRICE_FIELDS if not item["price"].get(f)]
    if missing:
        raise ValueError(f"Missing required price fields: {missing}")


def validate_item(item: dict) -> list[str]:
    """Returns a list of validation error messages (empty list = valid)."""
    return [e.message for e in VALIDATOR.iter_errors(item)]


if __name__ == "__main__":
    # quick manual test using a fake fact sheet
    test_fact_sheet = {
        "item_id": "test-1",
        "product_name": "Handwoven Jute Bag",
        "short_description": "Handwoven jute tote, natural dye",
        "long_description": "A handwoven jute tote bag made by artisans in a small village cooperative.",
        "category": "textile",
        "price_final": 500,
        "price_mrp": 600,
        "stock_count": 10,
        "returnable": True,
        "return_window": "PT168H",
    }
    test_images = ["https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg"]
    test_thumbnail = "https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg"

    item = map_to_ondc_item(test_fact_sheet, test_images, test_thumbnail)
    errors = validate_item(item)

    if errors:
        print("Schema errors:")
        for e in errors:
            print(" -", e)
    else:
        print("Valid ONDC item!")
        print(json.dumps(item, indent=2))