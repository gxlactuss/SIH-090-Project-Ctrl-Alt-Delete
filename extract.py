"""
extract.py — Transcript -> Fact Sheet extraction (Gemini version)
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Core rule: extraction NEVER invents a value. If the artisan didn't say it,
the field stays None/empty. We enforce this two ways:
  1. The prompt explicitly instructs "leave unknown fields as null"
  2. We use Gemini's structured output (response_schema) so the model
     is forced to return exactly this shape, not free-text prose.

Requires: pip install google-genai pydantic
Requires a GEMINI_API_KEY environment variable to be set.
Get a free key (no credit card) at: https://aistudio.google.com/apikey
"""

import os
from google import genai
from pydantic import BaseModel
from factsheet_schema import FactSheet, find_missing_required
from gemini_utils import generate_content_with_retry

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))

MODEL = "gemini-3.5-flash-lite"  # lighter/cheaper tier — trying this since
                                   # gemini-3.6-flash has been hitting high-demand 503s


# Narrower schema for just what extraction should fill in.
# (FactSheet also has fields like price_final, item_id, missing_fields
# that are computed elsewhere, not extracted from the transcript.)
class ExtractedFields(BaseModel):
    product_name: str | None = None
    category: str | None = None
    materials: str | None = None
    dimensions: str | None = None
    color: str | None = None
    cost_of_materials: float | None = None
    hours_spent: float | None = None
    stock_count: int | None = None
    returnable: bool | None = None


EXTRACTION_SYSTEM_PROMPT = """You extract product facts from an artisan's spoken description \
(already transcribed and translated to English) into a structured fact sheet.

STRICT RULE: only record what the artisan actually said. If a field was not \
mentioned at all, set it to null. Never guess, infer, estimate, or fill in a \
"reasonable" value. It is always better to leave a field null than to invent \
a value the artisan did not state.

Do not round or convert units unless the artisan's own words make the value \
unambiguous (e.g. "two hours" -> 2, "about 300 rupees" -> 300).

For "category", use these standard values when the artisan's described material \
or product type clearly matches one — prefer the MOST SPECIFIC match available:
  saree, kurta, scarf, fabric, jewellery, apparel, pottery, woodwork, basket, textile
Guidance: "saree" for sarees specifically (not just "textile"); "kurta" for kurtas/tunics; \
"scarf" for dupattas/shawls/scarves; "fabric" for unstitched/raw fabric; "basket" for \
woven baskets/kitchen storage items; "textile" only as a fallback when it's clearly \
fabric-based but doesn't match a more specific term above. "terracotta", "clay", or \
"ceramic" items are category "pottery" even if the artisan never says the word \
"pottery" directly. If nothing matches clearly, leave category null rather than guessing.
"""

# Few-shot example — expand this list with real transcripts once you have them
FEW_SHOT_EXAMPLE = {
    "transcript": "This is a handwoven jute bag. I used natural dyes, took me about "
                  "four hours to make. The jute cost me around two hundred rupees.",
    "expected": {
        "product_name": "Handwoven jute bag",
        "category": "textile",
        "materials": "jute, natural dye",
        "dimensions": None,
        "color": None,
        "cost_of_materials": 200,
        "hours_spent": 4,
        "stock_count": None,
        "returnable": None,
    },
}


def extract_fact_sheet(transcript: str) -> FactSheet:
    """
    Sends the transcript to Gemini with a forced response schema matching
    ExtractedFields. Returns a FactSheet with only what was actually said.
    """
    prompt = (
        f"Example transcript: \"{FEW_SHOT_EXAMPLE['transcript']}\"\n"
        f"Example output: {ExtractedFields(**FEW_SHOT_EXAMPLE['expected']).model_dump_json()}\n\n"
        f"Now extract from this transcript:\n\"{transcript}\""
    )

    response = generate_content_with_retry(
        client,
        model=MODEL,
        contents=prompt,
        config={
            "system_instruction": EXTRACTION_SYSTEM_PROMPT,
            "response_mime_type": "application/json",
            "response_schema": ExtractedFields,
        },
    )

    extracted: ExtractedFields = response.parsed
    return FactSheet(**extracted.model_dump())


if __name__ == "__main__":
    test_transcript = (
        "This is a clay pot, handmade. I used red clay from the local river. "
        "It took me about three hours. I have five of these ready."
    )

    sheet = extract_fact_sheet(test_transcript)
    print("Extracted fact sheet:")
    print(sheet.model_dump_json(indent=2))
    print("\nMissing required fields:", find_missing_required(sheet))