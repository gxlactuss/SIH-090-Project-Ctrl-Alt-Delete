"""
test_price_advisor.py — offline tests for the source-backed price engine.

Run:
    python -m pytest test_price_advisor.py -q
"""

import pytest

from factsheet_schema import FactSheet
from price_advisor import (
    DEFAULT_HOURLY_RATE,
    compute_price_floor,
    get_market_band,
    suggest_price,
)


def test_default_hourly_rate_is_source_backed_demo_proxy():
    assert DEFAULT_HOURLY_RATE == 90.0


def test_floor_with_materials_and_hours():
    assert compute_price_floor(200, 4) == 560.0


def test_floor_with_only_hours():
    assert compute_price_floor(None, 3) == 270.0


def test_floor_with_no_inputs():
    assert compute_price_floor(None, None) is None


def test_negative_cost_rejected():
    with pytest.raises(ValueError):
        compute_price_floor(-10, 2)


def test_negative_hours_rejected():
    with pytest.raises(ValueError):
        compute_price_floor(100, -2)


def test_market_band_requires_enough_source_observations():
    band = get_market_band("pottery")
    assert band is not None
    assert band["sample_size"] == 5
    assert band["source"] == "IndiaHandmade (Government of India, Ministry of Textiles)"


def test_market_band_case_insensitive():
    band = get_market_band(" POTTERY ")
    assert band["low"] == 450.0
    assert band["median"] == 1200.0
    assert band["high"] == 1700.0


def test_unknown_category_returns_none():
    assert get_market_band("painting") is None


def test_floor_below_market_p25_uses_reference_floor():
    sheet = FactSheet(category="pottery", hours_spent=3)
    result = suggest_price(sheet)

    assert result["floor"] == 270.0
    assert result["suggested_price"] == 450.0
    assert result["confidence"] == "medium"


def test_floor_inside_market_band_is_kept():
    sheet = FactSheet(
        category="kurta",
        cost_of_materials=300,
        hours_spent=6,
    )
    result = suggest_price(sheet)

    assert result["floor"] == 840.0
    assert result["suggested_price"] == 840.0
    assert result["confidence"] == "high"


def test_floor_above_market_p75_never_forced_down():
    sheet = FactSheet(
        category="pottery",
        cost_of_materials=2000,
        hours_spent=5,
    )
    result = suggest_price(sheet)

    assert result["floor"] == 2450.0
    assert result["suggested_price"] == 2450.0
    assert "above the observed P75 reference" in result["explanation"]


def test_market_only_is_low_confidence():
    sheet = FactSheet(category="kurta")
    result = suggest_price(sheet)

    assert result["suggested_price"] == 800.0
    assert result["confidence"] == "low"


def test_unknown_category_falls_back_to_cost_floor():
    sheet = FactSheet(category="woodwork", cost_of_materials=500, hours_spent=5)
    result = suggest_price(sheet)

    assert result["suggested_price"] == 950.0
    assert result["confidence"] == "medium"


def test_engine_does_not_mutate_price_final():
    sheet = FactSheet(
        category="pottery",
        cost_of_materials=200,
        hours_spent=4,
    )

    suggest_price(sheet)
    assert sheet.price_final is None
