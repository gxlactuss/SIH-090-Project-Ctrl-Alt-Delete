"""Deterministic price advisor stage."""
from app.services.pipeline.context import PipelineContext, PriceStageOutput
from app.services.pipeline.result import StageResult


class PriceStage:
    """Deterministic placeholder for fair pricing recommendations."""
    name: str = "price"

    def run(self, context: PipelineContext) -> StageResult:
        """Consume fact sheet output to produce price bounds and recommendation."""
        if context.fact_sheet_output is None:
            return StageResult.attention("Missing prerequisite fact sheet for pricing")

        output = PriceStageOutput(
            currency="INR",
            min_price=1200.0,
            max_price=1800.0,
            recommended_price=1500.0,
            confidence=0.92,
        )
        context.price_output = output
        return StageResult.ok(output=output, metadata={"currency": "INR", "recommended": 1500.0})
