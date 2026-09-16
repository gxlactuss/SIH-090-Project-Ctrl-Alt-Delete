import io
from fastapi.testclient import TestClient
from app.main import app
from app.schemas.enums import ListingState, MediaType

client = TestClient(app)


def test_health_endpoint_intact() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_get_seller_profile() -> None:
    import uuid
    from app.core.security import get_current_seller
    from app.models.seller import Seller

    mock_seller = Seller(
        id=uuid.UUID("11111111-1111-1111-1111-111111111111"),
        name="Artisan Radha Devi",
        language="hi",
        cluster="Madhubani Cluster",
        ondc_seller_id="ONDC-SELL-IND-9876",
    )
    app.dependency_overrides[get_current_seller] = lambda: mock_seller
    try:
        response = client.get("/api/v1/seller", headers={"Authorization": "Bearer test-token"})
        assert response.status_code == 200
        data = response.json()
        assert "id" in data
        assert "name" in data
        assert "language" in data
        assert "cluster" in data
        assert "ondc_seller_id" in data
    finally:
        app.dependency_overrides.pop(get_current_seller, None)


def test_create_listing() -> None:
    # Valid creation
    response = client.post("/api/v1/listings", json={"client_item_id": "mobile-item-123"})
    assert response.status_code == 200
    data = response.json()
    assert data["client_item_id"] == "mobile-item-123"
    assert data["state"] == ListingState.queued.value
    assert "id" in data

    # Invalid creation - missing required field
    bad_response = client.post("/api/v1/listings", json={})
    assert bad_response.status_code == 422


def test_get_listing() -> None:
    response = client.get("/api/v1/listings/lst-100")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "lst-100"
    assert "client_item_id" in data
    assert data["state"] in [s.value for s in ListingState]


def test_list_seller_listings() -> None:
    response = client.get("/api/v1/listings")
    assert response.status_code == 200
    data = response.json()
    assert "items" in data
    assert isinstance(data["items"], list)
    assert len(data["items"]) > 0
    for item in data["items"]:
        assert "id" in item
        assert "client_item_id" in item
        assert item["state"] in [s.value for s in ListingState]


def test_media_upload_contract() -> None:
    import tempfile
    import uuid
    from app.core.config import settings
    from app.core.security import get_current_seller
    from app.models.seller import Seller

    mock_seller = Seller(
        id=uuid.UUID("11111111-1111-1111-1111-111111111111"),
        name="Artisan Radha Devi",
        language="hi",
        cluster="Madhubani Cluster",
        ondc_seller_id="ONDC-SELL-IND-9876",
    )
    app.dependency_overrides[get_current_seller] = lambda: mock_seller
    headers = {"Authorization": "Bearer test-token"}

    with tempfile.TemporaryDirectory() as tmp_dir:
        orig_storage = settings.MEDIA_STORAGE_DIR
        settings.MEDIA_STORAGE_DIR = tmp_dir
        try:
            # Test valid image upload
            file_content = b"fake-image-bytes"
            files = {"file": ("test_art.jpg", io.BytesIO(file_content), "image/jpeg")}
            data = {"media_type": MediaType.image.value}

            response = client.post("/api/v1/listings/lst-100/media", files=files, data=data, headers=headers)
            assert response.status_code == 200
            res_data = response.json()
            assert res_data["listing_id"] == "lst-100"
            assert res_data["media_type"] == "image"
            assert res_data["status"] == "uploaded"
            assert "id" in res_data

            # Test valid audio upload
            audio_content = b"fake-audio-bytes"
            files_audio = {"file": ("recording.wav", io.BytesIO(audio_content), "audio/wav")}
            data_audio = {"media_type": MediaType.audio.value}

            response_audio = client.post(
                "/api/v1/listings/lst-100/media", files=files_audio, data=data_audio, headers=headers
            )
            assert response_audio.status_code == 200
            assert response_audio.json()["media_type"] == "audio"

            # Test invalid media_type
            bad_files = {"file": ("test.txt", io.BytesIO(b"data"), "text/plain")}
            bad_data = {"media_type": "video"}
            bad_response = client.post(
                "/api/v1/listings/lst-100/media", files=bad_files, data=bad_data, headers=headers
            )
            assert bad_response.status_code == 422
        finally:
            settings.MEDIA_STORAGE_DIR = orig_storage
            app.dependency_overrides.pop(get_current_seller, None)


def test_get_listing_status() -> None:
    response = client.get("/api/v1/listings/lst-100/status")
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert data["state"] in [s.value for s in ListingState]


def test_get_listing_attention() -> None:
    response = client.get("/api/v1/listings/lst-100/attention")
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert isinstance(data["needs_attention"], bool)
    assert "question" in data
    assert "field" in data


def test_get_listing_readback() -> None:
    response = client.get("/api/v1/listings/lst-100/readback")
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert "language" in data
    assert "title" in data
    assert "description" in data
    assert "price" in data
    assert "audio_url" in data


def test_approve_listing() -> None:
    # Valid approval
    response = client.post("/api/v1/listings/lst-100/approval", json={"approved": True})
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert data["approved"] is True
    assert data["state"] == ListingState.ready.value

    # Invalid body
    bad_response = client.post("/api/v1/listings/lst-100/approval", json={"approved": "not-a-bool"})
    assert bad_response.status_code == 422


def test_get_listing_suggestions() -> None:
    response = client.get("/api/v1/listings/lst-100/suggestions")
    assert response.status_code == 200
    data = response.json()
    assert "items" in data
    assert isinstance(data["items"], list)
    for item in data["items"]:
        assert "id" in item
        assert "field" in item
        assert "value" in item
        assert "reason" in item


def test_approve_suggestion() -> None:
    response = client.post(
        "/api/v1/listings/lst-100/suggestions/sug-001/approval",
        json={"approved": True},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert data["suggestion_id"] == "sug-001"
    assert data["approved"] is True


def test_record_listing_consent() -> None:
    response = client.post(
        "/api/v1/listings/lst-100/consent",
        json={"photo": True, "story": True},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert data["photo"] is True
    assert data["story"] is True
    assert data["ready_to_publish"] is True

    # Test invalid consent body
    bad_response = client.post("/api/v1/listings/lst-100/consent", json={"photo": "yes"})
    assert bad_response.status_code == 422


def test_publish_listing() -> None:
    response = client.post("/api/v1/listings/lst-100/publish")
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert data["state"] == ListingState.published.value
    assert "preview_url" in data


def test_get_listing_preview() -> None:
    response = client.get("/api/v1/listings/lst-100/preview")
    assert response.status_code == 200
    data = response.json()
    assert data["listing_id"] == "lst-100"
    assert "title" in data
    assert "description" in data
    assert "price" in data
    assert "image_urls" in data
    assert isinstance(data["image_urls"], list)


def test_openapi_schema_contains_all_routes() -> None:
    response = client.get("/openapi.json")
    assert response.status_code == 200
    schema = response.json()

    paths = schema["paths"]
    # Check root health check
    assert "/health" in paths

    # Check all 14 v1 endpoint paths
    expected_paths = [
        "/api/v1/seller",
        "/api/v1/listings",
        "/api/v1/listings/{listing_id}",
        "/api/v1/listings/{listing_id}/media",
        "/api/v1/listings/{listing_id}/status",
        "/api/v1/listings/{listing_id}/attention",
        "/api/v1/listings/{listing_id}/readback",
        "/api/v1/listings/{listing_id}/approval",
        "/api/v1/listings/{listing_id}/suggestions",
        "/api/v1/listings/{listing_id}/suggestions/{suggestion_id}/approval",
        "/api/v1/listings/{listing_id}/consent",
        "/api/v1/listings/{listing_id}/publish",
        "/api/v1/listings/{listing_id}/preview",
    ]

    for ep in expected_paths:
        assert ep in paths, f"Path {ep} missing from OpenAPI schema"
