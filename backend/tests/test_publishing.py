from app.services.publishing.base import (
    CanonicalListing,
    PublicationResult,
    PublicationValidationResult,
    PublishingAdapter,
)
from app.services.publishing.ondc import ONDCPublishingAdapter


def test_publishing_adapter_imports_and_protocol() -> None:
    """Verify that the publishing protocol and models can be imported and instantiated."""
    listing = CanonicalListing(
        id="test-listing-1",
        title="Handcrafted Brass Bell",
        description="Authentic bell handmade by local artisan",
        price=350.0,
        currency="INR",
        category="Handicrafts",
        materials=["Brass"],
        media_urls=["https://example.com/bell.jpg"],
    )
    assert listing.id == "test-listing-1"
    assert listing.price == 350.0
    assert "Brass" in listing.materials


def test_ondc_adapter_implements_protocol() -> None:
    """Verify that ONDCPublishingAdapter implements the PublishingAdapter protocol."""
    adapter = ONDCPublishingAdapter()
    assert isinstance(adapter, PublishingAdapter)
    assert adapter.channel_name == "ondc"


def test_ondc_adapter_deterministic_publish_success() -> None:
    """Verify mock ONDC adapter produces deterministic publish output on valid listing."""
    adapter = ONDCPublishingAdapter()
    listing = CanonicalListing(
        id="listing-xyz-101",
        title="Madhubani Painting",
        description="Traditional handmade folk art",
        price=1200.0,
        currency="INR",
        media_urls=["https://example.com/art.jpg"],
    )

    validation = adapter.validate(listing)
    assert isinstance(validation, PublicationValidationResult)
    assert validation.is_valid is True
    assert validation.channel == "ondc"
    assert len(validation.errors) == 0

    result = adapter.publish(listing)
    assert isinstance(result, PublicationResult)
    assert result.success is True
    assert result.channel == "ondc"
    assert result.external_id == "ondc-item-listing-xyz-101"
    assert result.status == "published"
    assert "mock-bpp-listing-factory" in result.details.get("bpp_id", "")


def test_ondc_adapter_deterministic_validation_failure() -> None:
    """Verify mock ONDC adapter handles validation failures deterministically."""
    adapter = ONDCPublishingAdapter()
    invalid_listing = CanonicalListing(
        id="listing-invalid",
        title="",
        description="",
        price=-10.0,
    )

    validation = adapter.validate(invalid_listing)
    assert validation.is_valid is False
    assert len(validation.errors) >= 3

    result = adapter.publish(invalid_listing)
    assert result.success is False
    assert result.channel == "ondc"
    assert result.status == "validation_failed"
    assert result.external_id is None
