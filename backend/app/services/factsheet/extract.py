"""
extract.py — Transcript -> Fact Sheet extraction
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Core rule: extraction NEVER invents a value. If the artisan didn't say it,
the field stays None/empty. We enforce this two ways:
  1. The prompt explicitly instructs "leave unknown fields as null"
  2. We use Gemini's structured output (response_schema) so the model
     is forced to return exactly this shape, not free-text prose.

The call itself is the backend's multimodal GeminiExtractor, which already
sees the photograph, carries the header auth, retries and fallback models,
and now asks for every field below. This module turns its answer into the
FactSheet the rest of the language layer and the ONDC mapper speak.
"""

from typing import Any, Mapping, Optional

from app.services.factsheet.schema import FactSheet, find_missing_required, normalize_category
from app.services.llm.gemini import GeminiExtractionResult, GeminiExtractor


def _text(value: Any) -> Optional[str]:
    if value is None:
        return None
    if isinstance(value, (list, tuple, set)):
        parts = [str(v).strip() for v in value if str(v).strip()]
        return ", ".join(parts) or None
    text = str(value).strip()
    return text or None


def fact_sheet_from_attributes(
    title: Optional[str],
    material: Optional[str],
    attributes: Mapping[str, Any],
) -> FactSheet:
    """A FactSheet holding only what the extraction actually found."""
    stock = attributes.get("stock_count")
    return FactSheet(
        product_name=_text(title),
        category=normalize_category(attributes.get("category")),
        materials=_text(material),
        dimensions=_text(attributes.get("dimensions")),
        color=_text(attributes.get("primary_colors")),
        cost_of_materials=attributes.get("cost_of_materials"),
        hours_spent=attributes.get("hours_spent"),
        stock_count=int(stock) if stock is not None else None,
        returnable=attributes.get("returnable"),
    )


def fact_sheet_from_extraction(extraction: GeminiExtractionResult) -> FactSheet:
    return fact_sheet_from_attributes(
        extraction.title,
        extraction.material,
        extraction.attributes,
    )


def extract_fact_sheet(transcript: str, extractor: Optional[GeminiExtractor] = None) -> FactSheet:
    """
    Sends the transcript to Gemini with a forced response schema and
    returns a FactSheet with only what was actually said. Raises when the
    model cannot be reached, rather than handing back canned facts, since
    the extraction test set is the evidence that nothing is invented.
    """
    extractor = extractor or GeminiExtractor()
    extraction = extractor.extract_fact_sheet(
        transcript=transcript,
        allow_synthetic_fallback=False,
    )
    return fact_sheet_from_extraction(extraction)


if __name__ == "__main__":
    test_transcript = (
        "This is a clay pot, handmade. I used red clay from the local river. "
        "It took me about three hours. I have five of these ready."
    )

    sheet = extract_fact_sheet(test_transcript)
    print("Extracted fact sheet:")
    print(sheet.model_dump_json(indent=2))
    print("\nMissing required fields:", find_missing_required(sheet))
