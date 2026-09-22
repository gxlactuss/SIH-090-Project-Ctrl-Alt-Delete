"""
writer.py — Fact Sheet -> Description writer
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Core rule: the writer may use NOTHING except what's already on the fact
sheet. No inventing materials, no assuming a story, no adding claims the
artisan never made (e.g. "eco-friendly", "premium quality") unless those
exact facts are present on the sheet. This keeps the listing honest and
keeps liability for false claims out of the pipeline.
"""

from typing import Optional

from app.services.factsheet.schema import FactSheet
from app.services.llm.gemini import GeminiExtractor


GENERATED_DESCRIPTIONS_SCHEMA = {
    "type": "OBJECT",
    "properties": {
        "short_description": {"type": "STRING"},      # English
        "long_description": {"type": "STRING"},       # English
        "short_description_hi": {"type": "STRING"},   # Hindi
        "long_description_hi": {"type": "STRING"},    # Hindi
    },
    "required": [
        "short_description",
        "long_description",
        "short_description_hi",
        "long_description_hi",
    ],
}


WRITER_SYSTEM_PROMPT = """You write product listing descriptions for handmade artisan \
goods, using ONLY the facts provided below. This is a strict rule:

- Do NOT invent, assume, or add any material, technique, origin story, or quality \
claim that is not explicitly present in the fact sheet.
- Do NOT use generic marketing words like "premium", "eco-friendly", "sustainable", \
"authentic", or "high quality" unless the fact sheet itself states something that \
directly supports that word.
- If a field is missing (null), simply do not mention it. Do not write around the gap \
with vague language.
- Write in a warm, simple, honest tone that reflects genuine handmade craftsmanship — \
but every claim must be traceable to a fact sheet field.

Generate FOUR fields:
- short_description: English, one sentence, under 20 words.
- long_description: English, 2-4 sentences, warm and descriptive, still fact-grounded only.
- short_description_hi: the SAME content as short_description, written naturally in \
Hindi (Devanagari script) — not a literal word-for-word translation, but the same \
facts expressed naturally for a Hindi-reading buyer.
- long_description_hi: the SAME content as long_description, written naturally in Hindi.

Both language versions must express exactly the same facts — never add or drop \
information between the English and Hindi versions.
"""


def _fact_sheet_to_prompt_facts(sheet: FactSheet) -> str:
    """Turns only the filled (non-null) fields into a clean fact list for the prompt."""
    facts = []
    if sheet.product_name:
        facts.append(f"Product name: {sheet.product_name}")
    if sheet.category:
        facts.append(f"Category: {sheet.category}")
    if sheet.materials:
        facts.append(f"Materials: {sheet.materials}")
    if sheet.dimensions:
        facts.append(f"Dimensions: {sheet.dimensions}")
    if sheet.color:
        facts.append(f"Color: {sheet.color}")
    if sheet.hours_spent:
        facts.append(f"Hours spent making it: {sheet.hours_spent}")
    return "\n".join(facts) if facts else "(no facts available)"


def write_descriptions(sheet: FactSheet, extractor: Optional[GeminiExtractor] = None) -> FactSheet:
    """
    Generates the English and Hindi short and long descriptions for the
    given fact sheet, using only its filled fields. Returns an updated copy
    of the sheet with those four fields set.
    """
    extractor = extractor or GeminiExtractor()
    facts_block = _fact_sheet_to_prompt_facts(sheet)

    prompt = f"Fact sheet:\n{facts_block}\n\nWrite the short and long description."

    generated = extractor.generate_json(
        system_instruction=WRITER_SYSTEM_PROMPT,
        prompt=prompt,
        response_schema=GENERATED_DESCRIPTIONS_SCHEMA,
    )

    def _clean(key: str) -> Optional[str]:
        value = generated.get(key)
        return value.strip() or None if isinstance(value, str) else None

    return sheet.model_copy(
        update={
            "short_description": _clean("short_description"),
            "long_description": _clean("long_description"),
            "short_description_hi": _clean("short_description_hi"),
            "long_description_hi": _clean("long_description_hi"),
        }
    )


if __name__ == "__main__":
    from app.services.factsheet.extract import extract_fact_sheet

    test_transcript = (
        "This is a clay pot, handmade. I used red clay from the local river. "
        "It took me about three hours. I have five of these ready."
    )

    sheet = extract_fact_sheet(test_transcript)
    print("Before writer (extraction only):")
    print(sheet.model_dump_json(indent=2))

    sheet_with_desc = write_descriptions(sheet)
    print("\nAfter writer (descriptions added):")
    print(f"EN short: {sheet_with_desc.short_description}")
    print(f"EN long:  {sheet_with_desc.long_description}")
    print(f"HI short: {sheet_with_desc.short_description_hi}")
    print(f"HI long:  {sheet_with_desc.long_description_hi}")
