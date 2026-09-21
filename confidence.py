"""
confidence.py — Confidence check + suggested additions
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Two responsibilities, per the project doc:
  1. Confidence check: decide if the listing is ready to publish, or if a
     missing required field needs ONE spoken question to the artisan.
  2. Suggested additions: optional extra details the artisan never said,
     offered one at a time — NEVER pre-accepted, NEVER added unless the
     artisan explicitly says yes. This is a hard rule, not a preference.
"""

import os
from google import genai
from pydantic import BaseModel
from factsheet_schema import FactSheet, find_missing_required
from gemini_utils import generate_content_with_retry

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
MODEL = "gemini-3.6-flash"


# ---------------------------------------------------------------------------
# 1. Confidence check
# ---------------------------------------------------------------------------

FIELD_QUESTIONS = {
    "product_name": "What would you like to call this item?",
    "category": "What kind of product is this — for example textile, pottery, or jewellery?",
    "price_final": "What price would you like to sell this for?",
    "stock_count": "How many of these do you have ready to sell?",
}


def run_confidence_check(sheet: FactSheet) -> FactSheet:
    """
    Updates missing_fields and ready_to_publish on the sheet.
    Does NOT guess any values — only reports what's missing.
    """
    missing = find_missing_required(sheet)
    updated = sheet.model_copy(
        update={
            "missing_fields": missing,
            "ready_to_publish": len(missing) == 0,
        }
    )
    return updated


def get_next_question(sheet: FactSheet) -> str | None:
    """
    Returns ONE spoken question for the first missing required field,
    or None if nothing is missing. Per the doc: "a missing slot becomes
    a question, never a guess" — and only one question at a time, so the
    artisan isn't overwhelmed.
    """
    if not sheet.missing_fields:
        return None
    first_missing = sheet.missing_fields[0]
    return FIELD_QUESTIONS.get(first_missing, f"Can you tell me the {first_missing}?")


# ---------------------------------------------------------------------------
# 2. Suggested additions
# ---------------------------------------------------------------------------

class Suggestion(BaseModel):
    field: str          # which FactSheet field this would fill/modify
    suggested_value: str
    spoken_prompt: str  # what gets read aloud to the artisan, phrased as a yes/no ask


class SuggestionList(BaseModel):
    suggestions: list[Suggestion]


SUGGESTION_SYSTEM_PROMPT = """You look at a fact sheet for a handmade product and \
suggest OPTIONAL additional details the artisan did not mention, that might help \
buyers. These are suggestions only — never facts.

Rules:
- Only suggest things that are plausible and harmless to ask about (e.g. season/occasion \
it suits, a care tip, a use case) — never invent a material, price, or specific claim \
as if it were true.
- Phrase spoken_prompt as a clear yes/no question, e.g. "Should I mention this is good \
for summer?" — never as a statement that assumes agreement.
- Suggest at most 3 additions. If nothing sensible comes to mind, return an empty list.
- Never suggest something that contradicts or duplicates a fact already on the sheet.
"""


def generate_suggestions(sheet: FactSheet) -> list[Suggestion]:
    """
    Generates candidate suggestions for the artisan to approve or skip.
    IMPORTANT: this only generates candidates. Nothing here is applied to
    the fact sheet. Use apply_suggestion() only after explicit approval.
    """
    facts = sheet.model_dump(exclude={"missing_fields", "ready_to_publish"})
    facts_text = "\n".join(f"{k}: {v}" for k, v in facts.items() if v is not None)

    prompt = f"Fact sheet:\n{facts_text}\n\nSuggest optional additions."

    response = generate_content_with_retry(
        client,
        model=MODEL,
        contents=prompt,
        config={
            "system_instruction": SUGGESTION_SYSTEM_PROMPT,
            "response_mime_type": "application/json",
            "response_schema": SuggestionList,
        },
    )

    result: SuggestionList = response.parsed
    return result.suggestions


def apply_suggestion(sheet: FactSheet, suggestion: Suggestion, approved: bool) -> FactSheet:
    """
    Applies a suggestion to the sheet ONLY if approved=True.
    This is the enforcement point for the "never added if they skip it" rule —
    call this only after the artisan has explicitly said yes to THIS suggestion.
    """
    if not approved:
        return sheet  # unchanged — skipped suggestions leave no trace

    if not hasattr(sheet, suggestion.field):
        raise ValueError(f"Suggestion targets unknown field: {suggestion.field}")

    return sheet.model_copy(update={suggestion.field: suggestion.suggested_value})


if __name__ == "__main__":
    from extract import extract_fact_sheet
    from writer import write_descriptions

    test_transcript = (
        "This is a clay pot, handmade. I used red clay from the local river. "
        "It took me about three hours. I have five of these ready."
    )

    sheet = extract_fact_sheet(test_transcript)
    sheet = write_descriptions(sheet)
    sheet = run_confidence_check(sheet)

    print("Missing fields:", sheet.missing_fields)
    print("Ready to publish:", sheet.ready_to_publish)

    question = get_next_question(sheet)
    if question:
        print(f"\nNext question to ask artisan: \"{question}\"")

    print("\n--- Suggested additions ---")
    suggestions = generate_suggestions(sheet)
    for s in suggestions:
        print(f"[{s.field}] \"{s.spoken_prompt}\" -> would set: {s.suggested_value}")

    # Simulate: artisan approves the FIRST suggestion only, skips the rest
    if suggestions:
        print(f"\nSimulating artisan says YES to: \"{suggestions[0].spoken_prompt}\"")
        sheet = apply_suggestion(sheet, suggestions[0], approved=True)
        print(f"Field '{suggestions[0].field}' is now: {getattr(sheet, suggestions[0].field)}")