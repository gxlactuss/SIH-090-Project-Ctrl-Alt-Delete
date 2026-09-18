"""Interactive voice-to-catalog demo and testing endpoint."""
import tempfile
from pathlib import Path
from typing import Any, Dict, Optional
import uuid

from fastapi import APIRouter, File, Form, HTTPException, UploadFile, status

from app.core.config import settings
from app.services.llm.gemini import GeminiExtractor
from app.services.pipeline.context import (
    FactSheetOutput,
    ImageStageOutput,
    PipelineContext,
    PriceStageOutput,
    SpeechStageOutput,
)
from app.services.pipeline.stages.price import PriceStage
from app.services.publishing.base import CanonicalListing
from app.services.publishing.google import GoogleMerchantPublishingAdapter
from app.services.publishing.meta import MetaPublishingAdapter
from app.services.publishing.ondc import ONDCPublishingAdapter
from app.services.voice.pipeline import VoiceStation

router = APIRouter(prefix="/voice", tags=["Voice Demo"])


@router.post(
    "/demo",
    status_code=status.HTTP_200_OK,
    summary="Interactive Voice-to-Catalog Tester",
    description="Upload or speak a voice note and observe the full Sarvam AI -> Gemini 2.0 Flash -> Modular Sheet -> Multi-Channel syndication pipeline.",
)
async def voice_to_catalog_demo(
    file: UploadFile = File(...),
    sarvam_key: Optional[str] = Form(None),
    gemini_key: Optional[str] = Form(None),
    model_name: Optional[str] = Form(None),
) -> Dict[str, Any]:
    effective_sarvam_key = sarvam_key or settings.SARVAM_API_KEY
    effective_gemini_key = gemini_key or settings.GEMINI_API_KEY
    effective_model = model_name or settings.GEMINI_MODEL

    # Save audio stream to temporary file
    suffix = Path(file.filename or "audio.wav").suffix or ".wav"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp_file:
        tmp_path = Path(tmp_file.name)
        content = await file.read()
        tmp_file.write(content)

    try:
        # Step 1: Voice Station (Sarvam AI translation)
        voice_station = VoiceStation(api_key=effective_sarvam_key)
        voice_res = voice_station.process_audio(tmp_path, allow_synthetic_fallback=True)

        # Step 2: Fact Sheet Extraction (Gemini 2.0 Flash)
        gemini_extractor = GeminiExtractor(api_key=effective_gemini_key, model_name=effective_model)
        extraction = gemini_extractor.extract_fact_sheet(
            transcript=voice_res.transcript,
            detected_language=voice_res.language_code,
            allow_synthetic_fallback=True,
        )

        # Step 3: Pricing Advisor Stage
        context = PipelineContext(listing_id=uuid.uuid4())
        context.image_output = ImageStageOutput(
            image_count=1,
            image_paths=["demo/product_clean.jpg"],
            detected_labels=[extraction.craft_type],
            dimensions=[{"width": 1024, "height": 1024}],
        )
        context.speech_output = SpeechStageOutput(
            audio_path=str(tmp_path),
            transcript=voice_res.transcript,
            language=voice_res.language_code,
            duration_seconds=voice_res.duration_seconds,
        )
        context.fact_sheet_output = FactSheetOutput(
            title=extraction.title,
            craft_type=extraction.craft_type,
            material=extraction.material,
            story_summary=extraction.story_summary,
            attributes=extraction.attributes,
        )

        price_stage = PriceStage()
        price_res = price_stage.run(context)
        price_output: PriceStageOutput = context.price_output

        # Step 4: Multi-Channel Syndication
        canonical = CanonicalListing(
            id=str(context.listing_id),
            title=extraction.title,
            description=extraction.story_summary,
            price=price_output.recommended_price,
            currency=price_output.currency,
            category=extraction.craft_type,
            materials=[extraction.material],
            dimensions=extraction.dimensions,
            media_urls=["https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800&q=80"],
            attributes=extraction.attributes,
        )

        ondc_pub = ONDCPublishingAdapter().publish(canonical)
        meta_pub = MetaPublishingAdapter().publish(canonical)
        google_pub = GoogleMerchantPublishingAdapter().publish(canonical)

        return {
            "status": "success",
            "voice_station": {
                "transcript": voice_res.transcript,
                "detected_language": voice_res.language_code,
                "duration_seconds": voice_res.duration_seconds,
                "live_api_used": bool(effective_sarvam_key),
            },
            "fact_sheet": {
                "title": extraction.title,
                "craft_type": extraction.craft_type,
                "material": extraction.material,
                "story_summary": extraction.story_summary,
                "stated_price": extraction.stated_price,
                "dimensions": extraction.dimensions,
                "origin": extraction.origin,
                "colors": extraction.colors,
                "missing_fields": extraction.missing_fields,
                "live_api_used": bool(effective_gemini_key),
                "model": effective_model,
            },
            "pricing": {
                "recommended_price": price_output.recommended_price,
                "min_price": price_output.min_price,
                "max_price": price_output.max_price,
                "currency": price_output.currency,
                "stated_by_artisan": price_res.metadata.get("stated_by_artisan", False),
            },
            "syndication": {
                "ondc": {
                    "channel": ondc_pub.channel,
                    "external_id": ondc_pub.external_id,
                    "status": ondc_pub.status,
                    "details": ondc_pub.details,
                },
                "meta_whatsapp": {
                    "channel": meta_pub.channel,
                    "external_id": meta_pub.external_id,
                    "status": meta_pub.status,
                    "details": meta_pub.details,
                },
                "google_merchant": {
                    "channel": google_pub.channel,
                    "external_id": google_pub.external_id,
                    "status": google_pub.status,
                    "details": google_pub.details,
                },
            },
        }
    finally:
        if tmp_path.exists():
            tmp_path.unlink()
