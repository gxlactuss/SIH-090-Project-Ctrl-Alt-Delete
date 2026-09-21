"""
lifecycle.py — Decides WHEN to publish, republish, or delist
Publishing to ONDC module (Shivam)

adapter.py has the HOW (mock/real push to ONDC). This file has the WHEN —
the trigger logic that decides which adapter method to call based on what
changed about a listing. This is meant to be called by whoever owns the
"a listing was edited" or "stock changed" event (likely Ayush Singh's
pipeline runner) — this module doesn't listen for events itself, it just
answers "given this old and new state, what should happen?"
"""


class ListingState:
    """Minimal snapshot of a listing's relevant state, before/after a change."""
    def __init__(self, item: dict, is_published: bool):
        self.item = item
        self.is_published = is_published
        self.stock_count = int(item["quantity"]["available"]["count"])


def decide_action(old_state: ListingState | None, new_state: ListingState) -> str:
    """
    Compares old vs new state and returns one of:
      "publish"   — not published yet, now ready (stock > 0) -> publish for the first time
      "republish" — already published, something changed, stock still > 0 -> push update
      "delist"    — was published, stock just hit 0 -> take it down
      "none"      — no action needed (e.g. still out of stock, or no real change)

    This function makes the DECISION only — it doesn't call the adapter.
    Keeping decision and action separate makes this easy to test without
    hitting the network every time.
    """
    if old_state is None:
        # First time we're seeing this listing
        return "publish" if new_state.stock_count > 0 else "none"

    was_published = old_state.is_published
    stock_now = new_state.stock_count
    stock_before = old_state.stock_count

    if was_published and stock_before > 0 and stock_now == 0:
        return "delist"

    if was_published and stock_now > 0:
        # Something about the item changed (price, description, stock topped up, etc.)
        # and it's still in stock -> push the update
        if old_state.item != new_state.item:
            return "republish"
        return "none"

    if not was_published and stock_now > 0:
        # Was delisted (or never published) and now has stock again
        return "publish"

    return "none"


def apply_lifecycle_action(adapter, action: str, item: dict) -> dict | None:
    """
    Actually calls the adapter based on a decided action. Separated from
    decide_action() so the decision logic can be unit-tested without a
    live (or even mock) adapter call.

    NOTE: your adapter.py only has push_item() and delist_item() — no
    separate republish_item(). push_item() is used for both a first-time
    publish and a republish (pushing an updated version), since ONDC
    doesn't distinguish these as different operations at the API level.
    """
    if action in ("publish", "republish"):
        return adapter.push_item(item)
    elif action == "delist":
        return adapter.delist_item(item["id"])
    elif action == "none":
        return None
    else:
        raise ValueError(f"Unknown lifecycle action: {action}")


if __name__ == "__main__":
    from app.services.ondc.mapper import map_to_ondc_item
    from app.services.ondc.adapter import MockOndcAdapter

    base_fact_sheet = {
        "item_id": "test-1",
        "product_name": "Handwoven Jute Bag",
        "short_description": "Handwoven jute tote, natural dye",
        "long_description": "A handwoven jute tote bag made by artisans.",
        "category": "textile",
        "price_final": 500,
        "price_mrp": 600,
        "stock_count": 10,
        "returnable": True,
        "return_window": "PT168H",
    }
    images = ["https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg"]
    thumbnail = "https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg"

    adapter = MockOndcAdapter()

    # --- Scenario 1: brand new listing, has stock -> should PUBLISH ---
    item_v1 = map_to_ondc_item(base_fact_sheet, images, thumbnail)
    state_v1_before = ListingState(item_v1, is_published=False)
    action = decide_action(None, state_v1_before)
    print(f"Scenario 1 (new listing): action = {action}")
    result = apply_lifecycle_action(adapter, action, item_v1)
    print(f"  -> {result}")
    # after a successful publish, the listing IS now published — track that
    state_v1_after = ListingState(item_v1, is_published=True)

    # --- Scenario 2: price changed, still in stock -> should REPUBLISH ---
    updated_fact_sheet = dict(base_fact_sheet, price_final=450)  # price drop
    item_v2 = map_to_ondc_item(updated_fact_sheet, images, thumbnail)
    state_v2 = ListingState(item_v2, is_published=True)
    action = decide_action(state_v1_after, state_v2)
    print(f"\nScenario 2 (price changed): action = {action}")
    result = apply_lifecycle_action(adapter, action, item_v2)
    print(f"  -> {result}")

    # --- Scenario 3: stock hits zero -> should DELIST ---
    zero_stock_fact_sheet = dict(updated_fact_sheet, stock_count=0)
    item_v3 = map_to_ondc_item(zero_stock_fact_sheet, images, thumbnail)
    state_v3 = ListingState(item_v3, is_published=True)
    action = decide_action(state_v2, state_v3)
    print(f"\nScenario 3 (stock hits zero): action = {action}")
    result = apply_lifecycle_action(adapter, action, item_v3)
    print(f"  -> {result}")

    # --- Scenario 4: still zero stock, nothing changed -> should do NOTHING ---
    action = decide_action(state_v3, state_v3)
    print(f"\nScenario 4 (already delisted, no change): action = {action}")
    result = apply_lifecycle_action(adapter, action, item_v3)
    print(f"  -> {result}")