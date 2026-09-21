"""Quality and confidence check stage."""
from typing import Optional

from app.services.factsheet.confidence import completeness, get_next_question, run_confidence_check
from app.services.factsheet.extract import fact_sheet_from_attributes
from app.services.pipeline.context import ConfidenceStageOutput, PipelineContext
from app.services.pipeline.persist import DEFAULT_QUANTITY
from app.services.pipeline.result import StageResult


class ConfidenceStage:
    """Checks the finished fact sheet against the fields a listing must have.

    The score is the share of required fields (name, category, price, stock)
    that are filled. A gap is recorded along with the one question that would
    close it, and becomes something to ask the artisan, never a guess. It does
    not stop the run unless a threshold is configured.
    """
    name: str = "confidence"

    def __init__(self, threshold: float = 0.0, forced_score: Optional[float] = None) -> None:
        self.threshold = threshold
        self.forced_score = forced_score

    def run(self, context: PipelineContext) -> StageResult:
        """Evaluate overall listing completeness and confidence across previous stage outputs."""
        if (
            context.image_output is None
            or context.speech_output is None
            or context.fact_sheet_output is None
            or context.price_output is None
        ):
            return StageResult.attention("Missing prerequisites for confidence assessment")

        facts = context.fact_sheet_output
        attributes = facts.attributes
        sheet = fact_sheet_from_attributes(facts.title, facts.material, facts.craft_type, attributes)
        stated = attributes.get("stated_price")
        sheet = sheet.model_copy(
            update={
                "price_final": stated if stated else context.price_output.recommended_price,
                "stock_count": sheet.stock_count or DEFAULT_QUANTITY,
            }
        )
        sheet = run_confidence_check(sheet)

        attributes["ready_to_publish"] = sheet.ready_to_publish
        attributes["required_missing"] = list(sheet.missing_fields)
        attributes["next_question"] = get_next_question(sheet)

        filled = completeness(sheet)
        score = self.forced_score if self.forced_score is not None else filled
        if score < self.threshold:
            return StageResult.attention(
                f"Confidence score {score:.2f} is below required threshold {self.threshold:.2f}",
                metadata={"score": score, "threshold": self.threshold},
            )

        output = ConfidenceStageOutput(
            overall_score=score,
            is_confident=True,
            confidence_by_stage={
                "fact_sheet": filled,
                "price": context.price_output.confidence,
            },
        )
        context.confidence_output = output
        return StageResult.ok(
            output=output,
            metadata={"overall_score": score, "missing": list(sheet.missing_fields)},
        )
