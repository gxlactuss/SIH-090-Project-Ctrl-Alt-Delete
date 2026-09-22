"""
price_advisor.py — Deterministic, source-backed artisan price engine.

Pricing policy:
1. Build a cost floor from the artisan's stated material cost + hours.
2. Use a configurable labour-rate benchmark. The demo default is a
   Maharashtra skilled-wage proxy, not a universal national artisan wage.
3. Use an observed retail reference corpus from current, source-backed
   listings. The market band is derived from the observed sample using
   P25 / median / P75.
4. Do NOT add an arbitrary blanket profit margin. The market benchmark is
   used to position the recommendation instead.
5. The engine never writes FactSheet.price_final. The seller must approve
   or change the recommendation.

This is a recommendation engine, not a guarantee of "fair value".
Market references are category-level observations and can be affected by
size, design, material, brand, discounts, geography and seller reputation.
"""

from __future__ import annotations

from datetime import date
from statistics import quantiles

from app.services.factsheet.schema import FactSheet


# ---------------------------------------------------------------------------
# Labour-rate policy
# ---------------------------------------------------------------------------

# Maharashtra Government notification for skilled workers in silver
# article/ornament manufacturing (30 Aug 2024):
#   Zone-I basic monthly skilled wage = ₹16,570.
# The notification explains that daily wage = monthly / 26 and part-time
# hourly wage = daily / 8 with a 15% increase.
#
# Derived benchmark:
#   (16,570 / 26 / 8) × 1.15 ≈ ₹91.61/hour
#
# We round to ₹90/hour for a simple demo default.
#
# IMPORTANT: this is NOT a universal artisan wage. For production use,
# the rate should be selected by seller state + craft/skill level.
DEFAULT_HOURLY_RATE = 90.0

# There is intentionally NO DEFAULT_MARGIN.
# A blanket 30% margin is not supported by the project architecture or a
# single authoritative national pricing standard for artisans.


# ---------------------------------------------------------------------------
# Source-backed market reference corpus
# ---------------------------------------------------------------------------
#
# These are observed prices from IndiaHandmade, a Government of India
# Ministry of Textiles marketplace for verified artisans/weavers/producer
# companies. We keep the raw observations rather than inventing a fixed
# low/median/high table.
#
# The engine derives:
#   market_low    = P25
#   market_median = P50
#   market_high   = P75
#
# Small / heterogeneous samples are deliberately not represented as
# "national market prices". Add more comparable observations as the team
# collects them.
#
# Source pages:
#   Pottery:
#     150  -> Handmade Decorative Kulhad Pot
#     450  -> Handmade Pottery Handi
#     1200 -> Handcrafted Terracotta Planter
#     1700 -> Terracotta Hand-Painted Decorative Pot
#     1950 -> Handmade Terracotta Handi
#
#   Baskets:
#     2500, 3500, 3500, 2450, 250, 1999
#
#   Kurtas:
#     1500, 1799, 499, 720, 499, 799, 2500, 499, 799
#
# Only categories with enough comparable observations are included.
# ---------------------------------------------------------------------------

MARKET_REFERENCE_OBSERVED_ON = date(2026, 9, 21).isoformat()

REFERENCE_SAMPLES = [
    # Pottery — IndiaHandmade
    {"category": "pottery", "price": 150, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalog/product/view/id/23340/s/decorative-kulhad-pot/category/2/"},
    {"category": "pottery", "price": 450, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalog/product/view/id/22350/s/handmade-pottery-handi/category/179/"},
    {"category": "pottery", "price": 1200, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/buy-terracotta-planter-online.html"},
    {"category": "pottery", "price": 1700, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalog/product/view/_ignore_category/1/id/11768/s/buy-handmade-terracotta-decorative-pot-online/"},
    {"category": "pottery", "price": 1950, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/handmade-terracotta-handi.html"},

    # Baskets — IndiaHandmade
    {"category": "basket", "price": 2500, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},
    {"category": "basket", "price": 3500, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},
    {"category": "basket", "price": 3500, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},
    {"category": "basket", "price": 2450, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},
    {"category": "basket", "price": 250, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},
    {"category": "basket", "price": 1999, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/catalogsearch/result/?q=bamboo+basket"},

    # Kurtas — IndiaHandmade
    {"category": "kurta", "price": 1500, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 1799, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 499, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 720, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 499, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 799, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 2500, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 499, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
    {"category": "kurta", "price": 799, "source": "IndiaHandmade", "source_url": "https://www.indiahandmade.com/men-s-wear/shirt/kurtas.html"},
]

MIN_MARKET_SAMPLE_SIZE = 5


def _normalise_category(category: str | None) -> str | None:
    if category is None:
        return None
    value = category.strip().lower()
    return value or None


def _round_price(value: float) -> float:
    """Round to a simple buyer-facing ₹10 amount."""
    rounded = float(round(value / 10) * 10)
    return rounded


def compute_price_floor(
    cost_of_materials: float | None,
    hours_spent: float | None,
    hourly_rate: float = DEFAULT_HOURLY_RATE,
) -> float | None:
    """
    Cost floor = material cost + labour cost.

    labour cost = hours_spent × hourly_rate

    Missing cost/hours are NOT invented:
      - neither supplied -> None
      - only one supplied -> use the supplied component
    """
    if cost_of_materials is None and hours_spent is None:
        return None

    if cost_of_materials is not None and cost_of_materials < 0:
        raise ValueError("cost_of_materials cannot be negative")

    if hours_spent is not None and hours_spent < 0:
        raise ValueError("hours_spent cannot be negative")

    if hourly_rate < 0:
        raise ValueError("hourly_rate cannot be negative")

    material_cost = float(cost_of_materials or 0.0)
    labour_cost = float(hours_spent or 0.0) * float(hourly_rate)
    direct_cost = material_cost + labour_cost

    if direct_cost <= 0:
        return None

    return round(direct_cost, 2)


def get_market_band(category: str | None) -> dict | None:
    """
    Derive an observed category price band from source-backed samples.

    Returns P25 / median / P75 and provenance.
    Returns None when there are too few observations.
    """
    category = _normalise_category(category)
    if category is None:
        return None

    rows = [row for row in REFERENCE_SAMPLES if row["category"] == category]

    if len(rows) < MIN_MARKET_SAMPLE_SIZE:
        return None

    prices = [float(row["price"]) for row in rows]
    low, median, high = quantiles(prices, n=4, method="inclusive")

    return {
        "low": round(low, 2),
        "median": round(median, 2),
        "high": round(high, 2),
        "sample_size": len(prices),
        "source": "IndiaHandmade (Government of India, Ministry of Textiles)",
        "observed_on": MARKET_REFERENCE_OBSERVED_ON,
        "source_urls": sorted({row["source_url"] for row in rows}),
    }


def suggest_price(
    sheet: FactSheet,
    hourly_rate: float = DEFAULT_HOURLY_RATE,
) -> dict:
    """
    Return a transparent price recommendation.

    Policy:
      A. Cost floor + market band:
         - floor below P25  -> suggest P25
         - floor inside band -> keep floor
         - floor above P75 -> keep floor and flag mismatch
      B. Cost floor only:
         - suggest the rounded floor
      C. Market band only:
         - suggest the observed median, but mark low confidence
      D. Neither:
         - no recommendation

    No automatic margin is added.
    The engine never writes sheet.price_final.
    """
    floor = compute_price_floor(
        sheet.cost_of_materials,
        sheet.hours_spent,
        hourly_rate=hourly_rate,
    )
    band = get_market_band(sheet.category)

    if floor is None and band is None:
        return {
            "floor": None,
            "market_band": None,
            "suggested_price": None,
            "confidence": "insufficient_data",
            "explanation": (
                "Not enough information for a source-backed recommendation. "
                "Need stated cost/hours and/or enough comparable market observations."
            ),
        }

    if floor is None:
        suggested = _round_price(band["median"])
        return {
            "floor": None,
            "market_band": band,
            "suggested_price": suggested,
            "confidence": "low",
            "explanation": (
                f"No cost/hours were stated. Using the observed market median "
                f"(₹{band['median']:.0f}) for '{_normalise_category(sheet.category)}' "
                "as a benchmark only."
            ),
        }

    if band is None:
        suggested = _round_price(floor)
        if suggested < floor:
            suggested += 10

        return {
            "floor": floor,
            "market_band": None,
            "suggested_price": suggested,
            "confidence": "medium",
            "explanation": (
                f"No sufficiently sized reference corpus exists for "
                f"'{sheet.category}'. Using the cost floor of ₹{floor:.0f}; "
                "the labour-rate benchmark is configurable."
            ),
        }

    if floor < band["low"]:
        suggested = band["low"]
        explanation = (
            f"Cost floor (₹{floor:.0f}) is below the observed P25 market "
            f"reference (₹{band['low']:.0f}) for "
            f"'{_normalise_category(sheet.category)}'. "
            f"Suggesting the P25 reference rather than adding an arbitrary margin."
        )
        confidence = "medium"
    elif floor <= band["high"]:
        suggested = floor
        explanation = (
            f"Cost floor (₹{floor:.0f}) is inside the observed P25–P75 "
            f"reference band (₹{band['low']:.0f}–₹{band['high']:.0f}) for "
            f"'{_normalise_category(sheet.category)}'. Keeping the cost floor."
        )
        confidence = "high"
    else:
        suggested = floor
        explanation = (
            f"Cost floor (₹{floor:.0f}) is above the observed P75 reference "
            f"(₹{band['high']:.0f}) for '{_normalise_category(sheet.category)}'. "
            "The engine does not force the price below the seller's stated-cost "
            "floor; the market mismatch is flagged."
        )
        confidence = "medium"

    suggested = _round_price(suggested)
    if suggested < floor:
        suggested = float(int(floor // 10 + 1) * 10)

    return {
        "floor": floor,
        "market_band": band,
        "suggested_price": suggested,
        "confidence": confidence,
        "explanation": explanation,
    }


if __name__ == "__main__":
    examples = [
        FactSheet(category="pottery", hours_spent=3),
        FactSheet(category="pottery", cost_of_materials=200, hours_spent=4),
        FactSheet(category="kurta", cost_of_materials=300, hours_spent=6),
        FactSheet(category="woodwork", cost_of_materials=500, hours_spent=5),
        FactSheet(category="unknown"),
    ]

    for index, sheet in enumerate(examples, 1):
        print(f"\nTest {index}:")
        print(suggest_price(sheet))
