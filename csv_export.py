"""
csv_export.py — Backup CSV export of ONDC items
Publishing to ONDC module (Shivam)

Flattens a validated ONDC item dict (or list of them) into a row-based CSV,
so a seller/admin always has a plain spreadsheet copy of every listing
even if the live ONDC push fails or the network is down.
"""

import csv
import os

CSV_FIELDS = [
    "id",
    "name",
    "short_desc",
    "long_desc",
    "symbol_url",
    "image_urls",
    "category_id",
    "price_value",
    "price_maximum_value",
    "currency",
    "stock_available",
    "stock_maximum",
    "returnable",
    "return_window",
    "cancellable",
    "available_on_cod",
    "time_to_ship",
]


def _flatten_item(item: dict) -> dict:
    """Turn a nested ONDC item dict into one flat row dict for CSV writing."""
    return {
        "id": item.get("id", ""),
        "name": item.get("descriptor", {}).get("name", ""),
        "short_desc": item.get("descriptor", {}).get("short_desc", ""),
        "long_desc": item.get("descriptor", {}).get("long_desc", ""),
        "symbol_url": item.get("descriptor", {}).get("symbol", ""),
        # multiple images -> one cell, pipe-separated (Excel/Sheets friendly)
        "image_urls": "|".join(item.get("descriptor", {}).get("images", [])),
        "category_id": item.get("category_id", ""),
        "price_value": item.get("price", {}).get("value", ""),
        "price_maximum_value": item.get("price", {}).get("maximum_value", ""),
        "currency": item.get("price", {}).get("currency", ""),
        "stock_available": item.get("quantity", {}).get("available", {}).get("count", ""),
        "stock_maximum": item.get("quantity", {}).get("maximum", {}).get("count", ""),
        "returnable": item.get("@ondc/org/returnable", ""),
        "return_window": item.get("@ondc/org/return_window", ""),
        "cancellable": item.get("@ondc/org/cancellable", ""),
        "available_on_cod": item.get("@ondc/org/available_on_cod", ""),
        "time_to_ship": item.get("@ondc/org/time_to_ship", ""),
    }


def export_items_to_csv(items: list[dict], filepath: str = "listings_export.csv") -> str:
    """
    Write one or more validated ONDC items to a CSV file.
    Appends a new row each call if the file already exists; creates it
    with headers if it doesn't. Returns the filepath written to.
    """
    file_exists = os.path.isfile(filepath)

    with open(filepath, mode="a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=CSV_FIELDS)
        if not file_exists:
            writer.writeheader()
        for item in items:
            writer.writerow(_flatten_item(item))

    return filepath


def export_single_item_to_csv(item: dict, filepath: str = "listings_export.csv") -> str:
    """Convenience wrapper for exporting just one item."""
    return export_items_to_csv([item], filepath)


if __name__ == "__main__":
    from mapper import map_to_ondc_item, validate_item

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
        print("Schema errors, not exporting:")
        for e in errors:
            print(" -", e)
    else:
        path = export_single_item_to_csv(item)
        print(f"Exported to {path}")