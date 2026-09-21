"""
run_pipeline.py — Full end-to-end demo: transcript -> ONDC item

This is the single script that ties BOTH your modules together:
  transcript -> extract -> writer -> confidence check -> price advisor
  -> (fill in price/stock) -> convert to dict -> map_to_ondc_item()

NOTE: this file needs to live somewhere that can import from BOTH your
`factsheet` folder AND your `try` (ONDC) folder. Easiest option for now:
copy mapper.py and ondc_schema.json into your `factsheet` folder so
everything is in one place. (Longer term, this is exactly the kind of
thing a proper project structure with folders-as-packages solves —
worth discussing with Ayush Singh once the pipeline runner exists.)
"""

from extract import extract_fact_sheet
from writer import write_descriptions
from confidence import run_confidence_check, get_next_question
from price_advisor import suggest_price
from mapper import map_to_ondc_item, validate_item, get_domain_for_item


def run_full_pipeline(transcript: str, image_urls: list[str], thumbnail_url: str):
    print("=" * 60)
    print("STEP 1: Extraction")
    print("=" * 60)
    sheet = extract_fact_sheet(transcript)
    print(sheet.model_dump_json(indent=2))

    print("\n" + "=" * 60)
    print("STEP 2: Description writer")
    print("=" * 60)
    sheet = write_descriptions(sheet)
    print(f"short: {sheet.short_description}")
    print(f"long:  {sheet.long_description}")

    print("\n" + "=" * 60)
    print("STEP 3: Confidence check")
    print("=" * 60)
    sheet = run_confidence_check(sheet)
    print(f"Missing fields: {sheet.missing_fields}")
    print(f"Ready to publish: {sheet.ready_to_publish}")

    if not sheet.ready_to_publish:
        question = get_next_question(sheet)
        print(f"\n>>> STOPPING: would ask artisan: \"{question}\"")
        print(">>> (In the real app, the artisan answers by voice, we fill")
        print(">>> the field, and re-run the confidence check. For this")
        print(">>> demo script, we'll manually fill the gaps below instead.)")

        # --- DEMO-ONLY: manually fill whatever's still missing ---
        # In production this comes from the artisan's spoken answer, not
        # hardcoded values. This block exists only so the script can
        # reach the ONDC mapping step for demo purposes.
        demo_fill = {
            "category": "pottery",
            "stock_count": sheet.stock_count or 5,
        }
        sheet = sheet.model_copy(update=demo_fill)
        sheet = run_confidence_check(sheet)
        print(f"\n[DEMO] Filled gaps manually: {demo_fill}")
        print(f"[DEMO] Missing fields now: {sheet.missing_fields}")

    print("\n" + "=" * 60)
    print("STEP 4: Price advisor")
    print("=" * 60)
    price_info = suggest_price(sheet)
    print(price_info)

    if sheet.price_final is None and price_info["suggested_price"] is not None:
        # DEMO-ONLY: in production, this suggested price would be READ BACK
        # to the artisan for approval, same as the suggestion-approval flow.
        sheet = sheet.model_copy(update={"price_final": price_info["suggested_price"]})
        print(f"[DEMO] Auto-accepted suggested price: ₹{sheet.price_final}")

    sheet = run_confidence_check(sheet)  # re-check now that price is filled

    print("\n" + "=" * 60)
    print("STEP 5: Convert to dict and map to ONDC item")
    print("=" * 60)
    if not sheet.ready_to_publish:
        print(f"Still missing: {sheet.missing_fields} — cannot map to ONDC yet.")
        return None

    fact_sheet_dict = sheet.model_dump()  # <-- the key conversion step
    item = map_to_ondc_item(fact_sheet_dict, image_urls, thumbnail_url)
    domain = get_domain_for_item(fact_sheet_dict)  # e.g. "ONDC:RET12" or "ONDC:RET16" —
                                                      # goes in the outer API request's
                                                      # context object, not inside item itself

    errors = validate_item(item)
    if errors:
        print("Schema errors:")
        for e in errors:
            print(" -", e)
        return None

    print(f"Valid ONDC item produced! (domain: {domain})")
    print(item)
    return {"domain": domain, "item": item}


if __name__ == "__main__":
    test_transcript = (
        "This is a clay pot, handmade. I used red clay from the local river. "
        "It took me about three hours. I have five of these ready."
    )
    test_images = ["https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500"]
    test_thumbnail = "https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=200"

    run_full_pipeline(test_transcript, test_images, test_thumbnail)