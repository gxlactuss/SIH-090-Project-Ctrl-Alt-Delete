"""Pipeline context holding media and sequential stage outputs."""
import uuid
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

from app.models.media import Media
from app.services.pipeline.result import StageResult


@dataclass
class ImageStageOutput:
    """Structured output from the image analysis station."""
    image_count: int
    image_paths: List[str]
    detected_labels: List[str]
    dimensions: List[Dict[str, int]] = field(default_factory=list)


@dataclass
class SpeechStageOutput:
    """Structured output from the speech processing station."""
    audio_path: str
    transcript: str
    language: str
    duration_seconds: float = 0.0


@dataclass
class FactSheetOutput:
    """Structured output from fact sheet synthesis and copywriting station."""
    title: str
    craft_type: str
    material: str
    story_summary: str
    attributes: Dict[str, Any] = field(default_factory=dict)


@dataclass
class PriceStageOutput:
    """Structured output from price recommendation station."""
    currency: str
    min_price: float
    max_price: float
    recommended_price: float
    confidence: float = 0.90


@dataclass
class ConfidenceStageOutput:
    """Structured output from quality and confidence assessment station."""
    overall_score: float
    is_confident: bool
    confidence_by_stage: Dict[str, float] = field(default_factory=dict)


@dataclass
class PipelineContext:
    """Evolving runtime context passed through the listing pipeline stages."""
    listing_id: uuid.UUID
    seller_id: Optional[uuid.UUID] = None
    media: List[Media] = field(default_factory=list)

    # Sequential stage outputs
    image_output: Optional[ImageStageOutput] = None
    speech_output: Optional[SpeechStageOutput] = None
    fact_sheet_output: Optional[FactSheetOutput] = None
    price_output: Optional[PriceStageOutput] = None
    confidence_output: Optional[ConfidenceStageOutput] = None

    # Tracking attempts and stage results
    stage_attempts: Dict[str, int] = field(default_factory=dict)
    stage_results: Dict[str, StageResult] = field(default_factory=dict)
