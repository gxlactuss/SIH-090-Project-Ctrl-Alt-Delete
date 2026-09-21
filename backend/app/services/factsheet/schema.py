"""
schema.py — The strict fact sheet schema
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Core rule from the project doc: "the strict fact sheet where every
unknown stays empty" — extraction must NEVER guess or invent a value.
If the artisan didn't say it, the field stays None. This schema is also
the exact shape mapper.py (the ONDC side) expects as input, so the two
modules line up without translation.
"""

from pydantic import BaseModel, Field, ConfigDict
from typing import Any, Optional


# The product categories extraction may choose from. These are exactly the
# keys of the ONDC mapper's CATEGORY_MAP, so any category extraction fills in
# can be published without translation.
CATEGORIES = (
    "saree",
    "kurta",
    "scarf",
    "fabric",
    "jewellery",
    "apparel",
    "pottery",
    "woodwork",
    "basket",
    "textile",
)


def normalize_category(value: Any) -> Optional[str]:
    """A known category in its canonical spelling, or None for anything else."""
    if not isinstance(value, str):
        return None
    text = value.strip().lower()
    if text == "jewelry":
        text = "jewellery"
    return text if text in CATEGORIES else None


class FactSheet(BaseModel):
    model_config = ConfigDict()
    # --- Identity ---
    item_id: Optional[str] = None
    product_name: Optional[str] = None

    # --- Descriptions (filled by the writer, not extraction directly) ---
    short_description: Optional[str] = None       # English
    long_description: Optional[str] = None        # English
    short_description_hi: Optional[str] = None     # Hindi — required per official PS
    long_description_hi: Optional[str] = None      # Hindi — required per official PS

    # --- Category ---
    category: Optional[str] = None          # e.g. "textile", "pottery", "jewellery"

    # --- Materials / attributes (used for suggestions + description writer) ---
    materials: Optional[str] = None
    dimensions: Optional[str] = None
    color: Optional[str] = None
    technique: Optional[str] = None
    origin: Optional[str] = None

    # --- Cost & pricing inputs (used by price_advisor, not the final price) ---
    cost_of_materials: Optional[float] = None
    hours_spent: Optional[float] = None
    price_final: Optional[float] = None      # set by price_advisor, not extraction
    price_mrp: Optional[float] = None

    # --- Stock ---
    stock_count: Optional[int] = None
    stock_max: Optional[int] = None

    # --- Seller policy choices (seller decides, never guessed) ---
    returnable: Optional[bool] = None
    return_window: Optional[str] = None      # ISO8601 duration, e.g. "PT168H"

    # --- Confidence / pipeline state ---
    missing_fields: list[str] = Field(default_factory=list)
    ready_to_publish: bool = False


def get_required_fields() -> list[str]:
    """
    Fields that MUST be filled before a listing can be marked
    ready_to_publish. Anything else can stay empty without blocking.
    Adjust this list as the team's confidence-check rules firm up.
    """
    return [
        "product_name",
        "category",
        "price_final",
        "stock_count",
    ]


def find_missing_required(sheet: FactSheet) -> list[str]:
    """Returns the list of required fields that are still empty."""
    required = get_required_fields()
    return [f for f in required if getattr(sheet, f) in (None, "", [])]


if __name__ == "__main__":
    # Quick manual test: an empty sheet should report all required fields missing
    empty = FactSheet()
    print("Missing from empty sheet:", find_missing_required(empty))

    # A partially filled sheet
    partial = FactSheet(
        product_name="Handwoven Jute Bag",
        category="textile",
        cost_of_materials=200,
        hours_spent=4,
    )
    print("Missing from partial sheet:", find_missing_required(partial))
    print(partial.model_dump_json(indent=2))
