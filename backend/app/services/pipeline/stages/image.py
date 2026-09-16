"""Deterministic image analysis stage."""
from app.schemas.enums import MediaType
from app.services.pipeline.context import ImageStageOutput, PipelineContext
from app.services.pipeline.result import StageResult


class ImageStage:
    """Deterministic placeholder for image processing and quality validation."""
    name: str = "image"

    def run(self, context: PipelineContext) -> StageResult:
        """Validate required image media exists and produce deterministic image analysis output."""
        image_media = [m for m in context.media if m.media_type == MediaType.image]
        if not image_media:
            return StageResult.attention("At least one image is required")

        image_paths = [m.storage_path or f"media/{m.id}.jpg" for m in image_media]
        output = ImageStageOutput(
            image_count=len(image_media),
            image_paths=image_paths,
            detected_labels=["handcrafted_art", "folk_painting", "natural_pigments"],
            dimensions=[{"width": 1024, "height": 768} for _ in image_media],
        )
        context.image_output = output
        return StageResult.ok(output=output, metadata={"processed_count": len(image_media)})
