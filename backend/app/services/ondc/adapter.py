"""
adapter.py — Pushes a validated ONDC Item to the network.
Publishing to ONDC module (Shivam)

Pattern: one interface (OndcAdapter), swap MockOndcAdapter for a
RealOndcAdapter later without touching any code that calls it.
"""

import uuid
import time
from abc import ABC, abstractmethod


class OndcAdapter(ABC):
    """Interface every adapter (mock or real) must implement."""

    @abstractmethod
    def push_item(self, item: dict) -> dict:
        """
        Push a validated ONDC item to the network.
        Returns a response dict: {"status": ..., "catalog_id": ..., "message": ...}
        """
        raise NotImplementedError


class MockOndcAdapter(OndcAdapter):
    """
    Always succeeds. Use this for every demo, and for local dev
    until the real ONDC seller-app registration/integration exists.
    """

    def push_item(self, item: dict) -> dict:
        # simulate a little network delay so the pipeline/demo feels real
        time.sleep(0.3)

        return {
            "status": "success",
            "catalog_id": f"mock-cat-{uuid.uuid4().hex[:8]}",
            "item_id": item["id"],
            "message": f"Item '{item['descriptor']['name']}' pushed to mock ONDC catalog.",
            "pushed_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        }

    def delist_item(self, item_id: str) -> dict:
        time.sleep(0.2)
        return {
            "status": "success",
            "item_id": item_id,
            "message": f"Item '{item_id}' delisted from mock ONDC catalog.",
        }


class RealOndcAdapter(OndcAdapter):
    """
    Placeholder for the real ONDC seller-app integration.
    Not implemented yet — fill in once seller registration / network
    credentials exist. Swap this in for MockOndcAdapter with no other
    code changes required, since both implement OndcAdapter.
    """

    def __init__(self, api_base_url: str, api_key: str):
        self.api_base_url = api_base_url
        self.api_key = api_key

    def push_item(self, item: dict) -> dict:
        raise NotImplementedError("Real ONDC push not implemented yet.")


# ---- quick manual test ----
if __name__ == "__main__":
    from app.services.ondc.mapper import map_to_ondc_item, validate_item

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
        print("Schema errors, not pushing:")
        for e in errors:
            print(" -", e)
    else:
        adapter = MockOndcAdapter()
        response = adapter.push_item(item)
        print("Push response:")
        print(response)