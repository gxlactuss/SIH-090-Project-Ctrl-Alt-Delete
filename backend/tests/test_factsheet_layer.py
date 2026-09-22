"""The language layer inside the pipeline.

Extraction's extra fields, the writer, suggested additions, the price advisor
and the confidence check all come from the fact sheet module. These tests pin
its core rule end to end: nothing the artisan did not say is ever filled in,
and an optional addition reaches the listing only after the artisan says yes.
"""
import uuid
from typing import Any, Dict, List

import httpx
import pytest

from app.services.factsheet.confidence import (
    completeness,
    generate_suggestions,
    get_next_question,
    run_confidence_check,
)
from app.services.factsheet.extract import fact_sheet_from_attributes
from app.services.factsheet.price_advisor import suggest_price
from app.services.factsheet.schema import FactSheet, normalize_category
from app.services.factsheet.writer import write_descriptions
from app.services.llm.gemini import GeminiExtractor
from app.services.pipeline.context import (
    FactSheetOutput,
    ImageStageOutput,
    PipelineContext,
    PriceStageOutput,
    SpeechStageOutput,
)
from app.services.pipeline.result import StageStatus
from app.services.pipeline.stages.confidence import ConfidenceStage
from app.services.pipeline.stages.description import DescriptionStage


class FakeModel:
    """Answers generate_json according to what the prompt asks for."""

    def __init__(self, descriptions: Dict[str, Any] = None, suggestions: List[Dict[str, Any]] = None, fail: bool = False):
        self.descriptions = descriptions or {}
        self.suggestions = suggestions or []
        self.fail = fail
        self.prompts: List[str] = []

    def generate_json(self, system_instruction: str, prompt: str, response_schema: Dict[str, Any], temperature: float = 0.2):
        self.prompts.append(prompt)
        if self.fail:
            raise RuntimeError("model unavailable")
        if "Suggest optional additions" in prompt:
            return {"suggestions": self.suggestions}
        return self.descriptions


DESCRIPTIONS = {
    "short_description": "A handmade clay pot.",
    "long_description": "A clay pot shaped by hand from red river clay.",
    "short_description_hi": "हाथ से बना मिट्टी का घड़ा।",
    "long_description_hi": "लाल नदी की मिट्टी से हाथ से बना घड़ा।",
}


def _facts(**attributes) -> FactSheetOutput:
    base = {"used_live_model": True, "missing_fields": []}
    base.update(attributes)
    return FactSheetOutput(
        title="Clay Pot",
        material="Red river clay",
        attributes=base,
    )


def _context(facts: FactSheetOutput) -> PipelineContext:
    context = PipelineContext(listing_id=uuid.uuid4())
    context.image_output = ImageStageOutput(image_count=1, image_paths=[], detected_labels=[])
    context.speech_output = SpeechStageOutput(audio_path="a.wav", transcript="A clay pot.", language="hi")
    context.fact_sheet_output = facts
    return context


# --------------------------------------------------------------------------
# Schema and extraction
# --------------------------------------------------------------------------


@pytest.mark.parametrize(
    "raw,expected",
    [("Pottery", "pottery"), (" saree ", "saree"), ("jewelry", "jewellery"), ("painting", None), (None, None), (7, None)],
)
def test_only_known_categories_survive(raw, expected):
    assert normalize_category(raw) == expected


def test_a_fact_sheet_holds_only_what_extraction_found():
    sheet = fact_sheet_from_attributes(
        "Clay Pot",
        "Red clay",
        {"category": "Pottery", "primary_colors": ["red", "brown"], "stock_count": 5},
    )
    assert sheet.category == "pottery"
    assert sheet.color == "red, brown"
    assert sheet.stock_count == 5
    assert sheet.cost_of_materials is None
    assert sheet.hours_spent is None
    assert sheet.returnable is None


def test_extraction_reads_the_new_fields_and_drops_non_answers(monkeypatch):
    body = (
        '{"title":"Clay Pot","material":"Clay",'
        '"category":"Pottery","cost_of_materials":120,"hours_spent":3,"stock_count":5,"returnable":"yes"}'
    )

    class _Response:
        status_code = 200

        def raise_for_status(self):
            return None

        @staticmethod
        def json():
            return {"candidates": [{"content": {"parts": [{"text": body}]}}]}

    class _Client:
        def __enter__(self):
            return self

        def __exit__(self, *_):
            return False

        def post(self, url, json=None, headers=None):
            return _Response()

    import app.services.llm.gemini as module

    monkeypatch.setattr(module.httpx, "Client", lambda *a, **k: _Client())
    result = GeminiExtractor(api_key="k", model_name="m", fallback_models=[]).extract_fact_sheet(
        transcript="A clay pot.", allow_synthetic_fallback=False
    )
    assert result.category == "pottery"
    assert result.cost_of_materials == 120.0
    assert result.hours_spent == 3.0
    assert result.stock_count == 5
    # Only a real boolean counts as the artisan's answer about returns.
    assert result.returnable is None
    assert result.attributes["category"] == "pottery"


def test_generate_json_shares_the_model_chain(monkeypatch):
    """A busy preferred model falls through to the next, as extraction does."""
    calls: List[str] = []

    class _Response:
        def __init__(self, url):
            self.status_code = 503 if "busy" in url else 200
            self.text = "busy"

        def raise_for_status(self):
            if self.status_code >= 400:
                raise httpx.HTTPStatusError("err", request=httpx.Request("POST", "http://x"), response=self)

        @staticmethod
        def json():
            return {"candidates": [{"content": {"parts": [{"text": '{"ok": true}'}]}}]}

    class _Client:
        def __enter__(self):
            return self

        def __exit__(self, *_):
            return False

        def post(self, url, json=None, headers=None):
            calls.append(url)
            assert headers["x-goog-api-key"] == "k"
            return _Response(url)

    import app.services.llm.gemini as module

    monkeypatch.setattr(module.httpx, "Client", lambda *a, **k: _Client())
    monkeypatch.setattr(module.time, "sleep", lambda _s: None)
    extractor = GeminiExtractor(api_key="k", model_name="busy", fallback_models=["spare"], max_attempts=2)

    assert extractor.generate_json("sys", "prompt", {"type": "OBJECT"}) == {"ok": True}
    assert [url.rsplit("/", 1)[1] for url in calls] == [
        "busy:generateContent",
        "busy:generateContent",
        "spare:generateContent",
    ]


def test_generate_json_needs_a_key(monkeypatch):
    import app.services.llm.gemini as module

    monkeypatch.setattr(module.settings, "GEMINI_API_KEY", None)
    with pytest.raises(RuntimeError):
        GeminiExtractor(model_name="m").generate_json("s", "p", {})


# --------------------------------------------------------------------------
# Writer and suggested additions
# --------------------------------------------------------------------------


def test_the_writer_sees_only_filled_facts():
    model = FakeModel(descriptions=DESCRIPTIONS)
    sheet = FactSheet(product_name="Clay Pot", materials="Red clay", color="Red")

    written = write_descriptions(sheet, model)

    assert written.long_description == DESCRIPTIONS["long_description"]
    assert written.long_description_hi == DESCRIPTIONS["long_description_hi"]
    prompt = model.prompts[0]
    assert "Materials: Red clay" in prompt
    assert "Color: Red" in prompt
    assert "Dimensions" not in prompt
    assert "Made in" not in prompt


def test_suggestions_are_capped_and_incomplete_ones_dropped():
    good = {"field": "occasion", "suggested_value": "summer", "spoken_prompt": "Should I say it suits summer?", "sentence": "It suits summer."}
    model = FakeModel(
        suggestions=[
            good,
            {**good, "spoken_prompt": ""},
            {"field": "care"},
            good,
            good,
            good,
        ]
    )
    suggestions = generate_suggestions(FactSheet(product_name="Clay Pot"), model)
    assert len(suggestions) == 3
    assert all(s.sentence == "It suits summer." for s in suggestions)


def test_canned_facts_are_never_written_up():
    model = FakeModel(descriptions=DESCRIPTIONS)
    context = _context(_facts(used_live_model=False))

    res = DescriptionStage(extractor=model).run(context)

    assert res.status == StageStatus.success
    assert model.prompts == []
    assert "long_description" not in context.fact_sheet_output.attributes


def test_the_description_stage_records_descriptions_and_additions():
    model = FakeModel(
        descriptions=DESCRIPTIONS,
        suggestions=[{"field": "occasion", "suggested_value": "gift", "spoken_prompt": "Should I say it makes a good gift?", "sentence": "It makes a good gift."}],
    )
    context = _context(_facts())

    res = DescriptionStage(extractor=model).run(context)

    attributes = context.fact_sheet_output.attributes
    assert res.status == StageStatus.success
    assert attributes["long_description"] == DESCRIPTIONS["long_description"]
    assert attributes["short_description_hi"] == DESCRIPTIONS["short_description_hi"]
    assert attributes["suggested_additions"][0]["sentence"] == "It makes a good gift."


def test_a_failed_model_call_never_stops_the_run():
    context = _context(_facts())

    res = DescriptionStage(extractor=FakeModel(fail=True)).run(context)

    assert res.status == StageStatus.success
    assert res.output == {"written": False, "suggestions": 0}
    assert "long_description" not in context.fact_sheet_output.attributes


# --------------------------------------------------------------------------
# Price advisor and confidence check
# --------------------------------------------------------------------------


def test_the_advisor_never_goes_below_the_artisans_costs():
    advice = suggest_price(FactSheet(category="pottery", cost_of_materials=900, hours_spent=10))
    # 900 + 10 x 90 = 1800, above the pottery P75 of 1700.
    assert advice["floor"] == 1800.0
    assert advice["suggested_price"] == 1800.0


def test_a_low_floor_is_nudged_up_to_the_market():
    advice = suggest_price(FactSheet(category="pottery", cost_of_materials=50))
    assert advice["floor"] == 50.0
    assert advice["suggested_price"] == 450.0


def test_categories_without_enough_observations_get_no_band():
    assert suggest_price(FactSheet(category="saree"))["market_band"] is None


def test_one_missing_field_becomes_one_question():
    sheet = run_confidence_check(FactSheet(product_name="Pot", category="pottery", stock_count=2))
    assert sheet.ready_to_publish is False
    assert sheet.missing_fields == ["price_final"]
    assert get_next_question(sheet) == "What price would you like to sell this for?"
    assert completeness(sheet) == 0.75


def test_the_confidence_stage_scores_completeness_and_records_the_gap():
    context = _context(_facts(category="pottery", stated_price=450.0))
    context.price_output = PriceStageOutput(currency="INR", recommended_price=450.0)

    res = ConfidenceStage().run(context)

    attributes = context.fact_sheet_output.attributes
    assert res.status == StageStatus.success
    assert context.confidence_output.overall_score == 1.0
    assert attributes["ready_to_publish"] is True
    assert attributes["next_question"] is None


def test_a_missing_category_is_asked_not_guessed():
    context = _context(_facts(stated_price=450.0))
    context.price_output = PriceStageOutput(currency="INR", recommended_price=450.0)

    ConfidenceStage().run(context)

    attributes = context.fact_sheet_output.attributes
    assert attributes["ready_to_publish"] is False
    assert attributes["required_missing"] == ["category"]
    assert "what kind of product" in attributes["next_question"].lower()
