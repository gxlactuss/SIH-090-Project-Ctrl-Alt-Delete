"""
preview.py — Read-only listing preview page generator
Publishing to ONDC module (Shivam)

Renders a validated ONDC item into a standalone HTML page the artisan
can open, check, and forward on WhatsApp. Uses Jinja2 + a template file
(templates/preview_template.html) so styling stays out of the Python code.

Folder layout expected:
  app/services/ondc/
    preview.py
    mapper.py
    ondc_schema.json
    templates/
      preview_template.html

The backend serves this page at /p/{listing_id} for every published listing;
that URL is the preview_url the app shares on WhatsApp and shows as a QR code.
"""

import os
from datetime import datetime, timezone
from typing import Optional
from jinja2 import Environment, FileSystemLoader, select_autoescape

TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "templates")


def render_preview_html(
    item: dict,
    short_desc_hi: Optional[str] = None,
    long_desc_hi: Optional[str] = None,
) -> str:
    """
    Renders the given ONDC item into an HTML string and returns it directly
    — no file written. This is what a FastAPI route should call, e.g.:

        from fastapi.responses import HTMLResponse

        @app.get("/preview/{item_id}")
        def preview(item_id: str):
            item = get_item_from_db(item_id)   # however Ayush's backend fetches it
            html = render_preview_html(item)
            return HTMLResponse(content=html)

    That gives a real URL (e.g. https://yourapi.com/preview/test-1) that
    Mohit's app can open in a WebView, or that gets shared on WhatsApp.
    """
    # Autoescaped: the page is public and every text on it came from a model
    # or from the artisan, so none of it may be read as markup.
    env = Environment(
        loader=FileSystemLoader(TEMPLATE_DIR),
        autoescape=select_autoescape(["html"]),
    )
    template = env.get_template("preview_template.html")

    return template.render(
        item=item,
        short_desc_hi=short_desc_hi,
        long_desc_hi=long_desc_hi,
        generated_at=datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
    )


def generate_preview_page(item: dict, output_path: str = "preview.html") -> str:
    """
    Local-testing convenience wrapper: renders the item and writes the
    HTML to a file on disk. Returns the path written to. Use
    render_preview_html() instead when serving over HTTP.
    """
    html = render_preview_html(item)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(html)

    return output_path


if __name__ == "__main__":
    from app.services.ondc.mapper import map_to_ondc_item, validate_item

    test_fact_sheet = {
        "item_id": "test-1",
        "product_name": "Handwoven Jute Bag",
        "short_description": "Handwoven jute tote, natural dye",
        "long_description": "A handwoven jute tote bag made by artisans in a small village cooperative, using traditional dyeing techniques passed down over three generations.",
        "category": "textile",
        "price_final": 500,
        "price_mrp": 600,
        "stock_count": 10,
        "returnable": True,
        "return_window": "PT168H",
    }
    test_images = [
        "https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg",
        "https://t4.ftcdn.net/jpg/21/85/97/55/240_F_2185975569_yQ94bZ1IzxWgL8T7huBGmd6pFemCHdnZ.jpg",
    ]
    test_thumbnail = "https://t4.ftcdn.net/jpg/17/76/48/97/240_F_1776489772_3LNX7AxpTkbTFZmk2J1qkCRSl6Shq2zb.jpg"

    item = map_to_ondc_item(test_fact_sheet, test_images, test_thumbnail)
    errors = validate_item(item)

    if errors:
        print("Schema errors, not generating preview:")
        for e in errors:
            print(" -", e)
    else:
        path = generate_preview_page(item)
        print(f"Preview page written to {path} — open it in a browser to check.")