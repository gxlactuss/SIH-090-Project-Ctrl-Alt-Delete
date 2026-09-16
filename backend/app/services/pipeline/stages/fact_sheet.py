"""Deterministic fact sheet generation stage."""
from app.services.pipeline.context import FactSheetOutput, PipelineContext
from app.services.pipeline.result import StageResult


class FactSheetStage:
    """Deterministic placeholder for synthesizing fact sheet and catalog copy."""
    name: str = "fact_sheet"

    def run(self, context: PipelineContext) -> StageResult:
        """Consume image and speech outputs to generate a structured artisan product fact sheet."""
        if context.image_output is None or context.speech_output is None:
            return StageResult.attention("Missing prerequisite image or speech analysis")

        output = FactSheetOutput(
            title="Handcrafted Madhubani Folk Painting",
            craft_type="Madhubani Art",
            material="Natural pigments on handmade paper",
            story_summary=context.speech_output.transcript,
            attributes={
                "dimensions": "1024x768",
                "origin": "Mithila region",
                "primary_colors": ["ochre", "indigo", "lampblack"],
                "image_count": context.image_output.image_count,
            },
        )
        context.fact_sheet_output = output
        return StageResult.ok(output=output, metadata={"attributes_count": len(output.attributes)})
