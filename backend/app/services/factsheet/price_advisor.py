"""
price_advisor.py — Price floor + market band suggestion
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

No LLM call needed here — this is plain arithmetic + a small lookup table,
per the project doc: "a floor from the cost and hours they state, and a
band from a reference table." Deliberately simple and deterministic, so
it never "hallucinates" a price — every number is traceable to either the
artisan's stated cost/hours or the reference table below.
"""

from app.services.factsheet.schema import FactSheet

DEFAULT_HOURLY_RATE = 50       # INR/hour — adjust with the team
DEFAULT_MARGIN = 0.30          # 30% margin over cost — adjust with the team

# Small reference table: category -> typical market price range (INR)
# Replace/expand with real data once the team has it (e.g. from Etsy
# datasets or GEM/ONDC category benchmarks discussed earlier).
REFERENCE_PRICES = {
    "textile":   {"low": 300,  "median": 600,  "high": 1500},
    "pottery":   {"low": 200,  "median": 450,  "high": 1200},
    "jewellery": {"low": 250,  "median": 800,  "high": 3000},
    "woodwork":  {"low": 400,  "median": 900,  "high": 2500},
}

# The more specific fabric categories extraction can choose share the
# textile band until the table has rows of their own.
BAND_PARENT = {
    "saree": "textile",
    "kurta": "textile",
    "scarf": "textile",
    "fabric": "textile",
    "apparel": "textile",
}


def compute_price_floor(
    cost_of_materials: float | None,
    hours_spent: float | None,
    hourly_rate: float = DEFAULT_HOURLY_RATE,
    margin: float = DEFAULT_MARGIN,
) -> float | None:
    """
    floor = (materials cost + labor cost) * (1 + margin)
    Returns None if we don't have enough info to compute anything —
    never guesses a floor out of thin air.
    """
    if cost_of_materials is None and hours_spent is None:
        return None

    material_cost = cost_of_materials or 0
    labor_cost = (hours_spent or 0) * hourly_rate

    if material_cost == 0 and labor_cost == 0:
        return None

    floor = (material_cost + labor_cost) * (1 + margin)
    return round(floor, 2)


def get_market_band(category: str | None) -> dict | None:
    """
    Looks up the reference low/median/high for a category.
    Returns None if the category isn't in the table or wasn't provided —
    never invents a band for an unknown category.
    """
    if category is None:
        return None

    key = category.lower()
    row = REFERENCE_PRICES.get(BAND_PARENT.get(key, key))
    if row is None:
        return None

    return dict(row)


def suggest_price(sheet: FactSheet) -> dict:
    """
    Returns a dict with:
      - floor: cost-based minimum (or None if not computable)
      - market_band: category-based low/median/high (or None if unknown category)
      - suggested_price: floor, nudged up toward the market median if the
        floor sits below the market's low end (still never below the floor)
      - explanation: short trace of how the number was reached, for transparency
    """
    floor = compute_price_floor(sheet.cost_of_materials, sheet.hours_spent)
    band = get_market_band(sheet.category)

    if floor is None and band is None:
        return {
            "floor": None,
            "market_band": None,
            "suggested_price": None,
            "explanation": "Not enough information yet — need cost/hours or a known category.",
        }

    if floor is None:
        suggested = band["median"]
        explanation = f"No cost/hours given — using market median for '{sheet.category}'."
    elif band is None:
        suggested = floor
        explanation = "No market data for this category — using cost-based floor only."
    else:
        if floor < band["low"]:
            # artisan's floor is unusually low vs. market — nudge toward market low,
            # but never suggest anything below their actual cost floor
            suggested = max(floor, band["low"])
            explanation = (
                f"Cost floor (₹{floor}) is below typical market range for "
                f"'{sheet.category}' (₹{band['low']}–₹{band['high']}) — "
                f"suggesting the market low instead."
            )
        else:
            suggested = floor
            explanation = f"Cost floor (₹{floor}) already sits within market range."

    return {
        "floor": floor,
        "market_band": band,
        "suggested_price": round(suggested, 2) if suggested else None,
        "explanation": explanation,
    }


if __name__ == "__main__":
    # Test case 1: full info, textile
    sheet1 = FactSheet(
        category="textile",
        cost_of_materials=200,
        hours_spent=4,
    )
    print("Test 1 (jute bag, textile):")
    print(suggest_price(sheet1))

    # Test case 2: no category, just cost/hours
    sheet2 = FactSheet(cost_of_materials=500, hours_spent=10)
    print("\nTest 2 (no category):")
    print(suggest_price(sheet2))

    # Test case 3: category but no cost/hours stated yet
    sheet3 = FactSheet(category="jewellery")
    print("\nTest 3 (jewellery, no cost/hours):")
    print(suggest_price(sheet3))

    # Test case 4: nothing at all
    sheet4 = FactSheet()
    print("\nTest 4 (empty sheet):")
    print(suggest_price(sheet4))