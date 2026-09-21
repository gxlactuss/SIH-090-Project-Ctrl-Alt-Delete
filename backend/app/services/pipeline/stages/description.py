"""Description Station: the language layer's writer and suggested additions.

Runs after the fact sheet. The writer turns only the facts the artisan gave
into English and Hindi short and long descriptions, and the suggestion step
offers up to three optional additions the artisan can say yes or no to. Both
are extra polish: if either call fails the listing keeps the fact sheet's own
summary and simply has no additions, so this stage never stops a run.
"""
import logging
from concurrent.futures import ThreadPoolExecutor
from typing import Callable, Optional, TypeVar

from app.services.factsheet.confidence import generate_suggestions
from app.services.factsheet.extract import fact_sheet_from_attributes
from app.services.factsheet.writer import write_descriptions
from app.services.llm.gemini import GeminiExtractor
from app.services.pipeline.context import PipelineContext
from app.services.pipeline.result import StageResult
from app.services.pipeline.stages.fact_sheet import _get_gemini_extractor

logger = logging.getLogger("app.services.pipeline.stages.description")

T = TypeVar("T")

DESCRIPTION_KEYS = (
    "short_description",
    "long_description",
    "short_description_hi",
    "long_description_hi",
)


class DescriptionStage:
    """Writes the listing's descriptions and gathers optional additions."""

    name: str = "description"

    def __init__(self, extractor: Optional[GeminiExtractor] = None) -> None:
        self._extractor = extractor

    def run(self, context: PipelineContext) -> StageResult:
        facts = context.fact_sheet_output
        if facts is None:
            return StageResult.attention("Missing prerequisite fact sheet for description")

        attributes = facts.attributes
        # Facts from the canned fallback are not the artisan's, so there is
        # nothing honest to write from and nothing worth suggesting.
        if not attributes.get("used_live_model"):
            summary = {"written": False, "suggestions": 0}
            return StageResult.ok(output=summary, metadata=summary)

        sheet = fact_sheet_from_attributes(facts.title, facts.material, facts.craft_type, attributes)
        extractor = self._extractor or _get_gemini_extractor()

        # Independent calls on a slow model, so they run side by side.
        with ThreadPoolExecutor(max_workers=2) as pool:
            written_future = pool.submit(write_descriptions, sheet, extractor)
            suggestions_future = pool.submit(generate_suggestions, sheet, extractor)
            written = _settle(written_future.result, "descriptions", context)
            suggestions = _settle(suggestions_future.result, "suggested additions", context)

        if written is not None:
            for key in DESCRIPTION_KEYS:
                value = getattr(written, key)
                if value:
                    attributes[key] = value

        if suggestions:
            attributes["suggested_additions"] = [s.model_dump() for s in suggestions]

        summary = {"written": written is not None, "suggestions": len(suggestions or [])}
        return StageResult.ok(output=summary, metadata=summary)


def _settle(result: Callable[[], T], what: str, context: PipelineContext) -> Optional[T]:
    try:
        return result()
    except Exception as exc:
        logger.warning("Listing %s -> could not generate %s: %s", context.listing_id, what, exc)
        return None

