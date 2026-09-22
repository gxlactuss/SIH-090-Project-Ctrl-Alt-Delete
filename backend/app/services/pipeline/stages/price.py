"""Price Advisor stage: fair pricing from the artisan's own numbers."""
import logging

from app.services.factsheet.price_advisor import suggest_price
from app.services.factsheet.schema import FactSheet, normalize_category
from app.services.pipeline.context import PipelineContext, PriceStageOutput
from app.services.pipeline.result import StageResult

logger = logging.getLogger("app.services.pipeline.stages.price")


class PriceStage:
    """Production Price Station: adopts the artisan's stated price, or advises one.

    Advice comes from the language layer's price advisor: a floor from the
    material cost and hours the artisan stated, and a band from observed
    market listings for the category. Every number is traceable to one of those. With
    neither, no price is invented and the artisan is asked for one instead.
    """

    name: str = "price"

    def run(self, context: PipelineContext) -> StageResult:
        """Consume fact sheet output to produce price bounds and recommendation."""
        if context.fact_sheet_output is None:
            return StageResult.attention("Missing prerequisite fact sheet for pricing")

        attributes = context.fact_sheet_output.attributes
        advice = suggest_price(
            FactSheet(
                category=normalize_category(attributes.get("category")),
                cost_of_materials=attributes.get("cost_of_materials"),
                hours_spent=attributes.get("hours_spent"),
            )
        )
        attributes["price_advice"] = advice

        stated_price = attributes.get("stated_price")
        floor = advice["floor"]
        band = advice["market_band"]

        # If the artisan explicitly stated a price in the audio note
        if stated_price is not None and float(stated_price) > 0:
            stated = float(stated_price)
            output = PriceStageOutput(
                currency="INR",
                min_price=round(stated * 0.90, 2),
                max_price=round(stated * 1.15, 2),
                recommended_price=round(stated, 2),
                confidence=0.96,
            )
            is_stated = True
        elif advice["suggested_price"] is not None:
            suggested = float(advice["suggested_price"])
            output = PriceStageOutput(
                currency="INR",
                min_price=float(floor) if floor is not None else float(band["low"]),
                max_price=max(float(band["high"]), suggested) if band else suggested,
                recommended_price=round(suggested, 2),
                # Both the artisan's costs and the market agree, or only one spoke.
                confidence=0.90 if floor is not None and band is not None else 0.75,
            )
            is_stated = False
        else:
            output = PriceStageOutput(currency="INR", confidence=0.0)
            is_stated = False

        context.price_output = output
        return StageResult.ok(
            output=output,
            metadata={
                "currency": "INR",
                "recommended": output.recommended_price,
                "stated_by_artisan": is_stated,
                "explanation": advice["explanation"],
            },
        )
