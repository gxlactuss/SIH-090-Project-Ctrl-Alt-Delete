"""Deterministic speech recognition stage."""
from app.schemas.enums import MediaType
from app.services.pipeline.context import PipelineContext, SpeechStageOutput
from app.services.pipeline.result import StageResult


class SpeechStage:
    """Deterministic placeholder for speech transcription and language detection."""
    name: str = "speech"

    def run(self, context: PipelineContext) -> StageResult:
        """Validate voice note audio media exists and produce deterministic transcript output."""
        audio_media = [m for m in context.media if m.media_type == MediaType.audio]
        if not audio_media:
            return StageResult.attention("Voice note audio is required")

        primary_audio = audio_media[0]
        output = SpeechStageOutput(
            audio_path=primary_audio.storage_path or f"media/{primary_audio.id}.wav",
            transcript="Traditional handmade folk painting crafted using organic mineral colors on handmade paper depicting nature motifs.",
            language="hi",
            duration_seconds=18.5,
        )
        context.speech_output = output
        return StageResult.ok(output=output, metadata={"detected_language": "hi"})
