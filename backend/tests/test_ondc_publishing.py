"""Publishing a listing to ONDC, and the share page the app sends on WhatsApp.

Publishing in the app now maps the listing's fact sheet to an ONDC Item,
validates it against the ONDC schema, pushes it through the adapter and keeps a
CSV backup, while the share page gives the preview_url the app has always
supported something to open. These run through the real API with a real photo
on disk.
"""
import csv
import uuid
from pathlib import Path
from typing import Generator

import pytest
from fastapi import Depends
from fastapi.testclient import TestClient
from PIL import Image
from sqlalchemy import create_engine, event
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from app.core.config import settings
from app.core.security import get_current_seller
from app.db.base import Base
from app.db.session import get_db
from app.main import app
from app.models.listing import Listing
from app.models.listing_result import ListingResult
from app.models.media import Media
from app.models.seller import Seller
from app.models.suggestion import Suggestion
from app.schemas.enums import ListingState, MediaType
from app.services.ondc import adapter as adapter_module
from app.services.ondc.catalog import OndcNotReady, item_for_listing

AUTH = {"Authorization": "Bearer test-token"}
SELLER_ID = uuid.UUID("22222222-2222-2222-2222-222222222222")


@pytest.fixture
def media_root(tmp_path, monkeypatch) -> Path:
    root = tmp_path / "media"
    root.mkdir()
    monkeypatch.setattr(settings, "MEDIA_STORAGE_DIR", str(root))
    monkeypatch.setattr(settings, "ONDC_EXPORT_CSV", None)
    monkeypatch.setattr(settings, "PUBLIC_BASE_URL", "https://share.example")
    monkeypatch.setattr(settings, "ONDC_ADAPTER", "mock")
    # The mock adapter pauses to feel like a network call; not here.
    monkeypatch.setattr(adapter_module.time, "sleep", lambda _s: None)
    return root


@pytest.fixture
def session_factory() -> Generator[sessionmaker, None, None]:
    engine = create_engine(
        "sqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )

    @event.listens_for(engine, "connect")
    def _fk(dbapi_connection, _record):
        cur = dbapi_connection.cursor()
        cur.execute("PRAGMA foreign_keys=ON")
        cur.close()

    Base.metadata.create_all(engine)
    factory = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    def override_get_db() -> Generator[Session, None, None]:
        session = factory()
        try:
            yield session
        finally:
            session.close()

    def override_get_current_seller(db: Session = Depends(get_db)) -> Seller:
        return db.query(Seller).filter(Seller.id == SELLER_ID).one()

    app.dependency_overrides[get_db] = override_get_db
    app.dependency_overrides[get_current_seller] = override_get_current_seller
    yield factory
    app.dependency_overrides.pop(get_db, None)
    app.dependency_overrides.pop(get_current_seller, None)
    Base.metadata.drop_all(engine)


@pytest.fixture
def client(session_factory, media_root) -> TestClient:
    return TestClient(app)


def _ready_listing(factory, media_root: Path, **result_fields) -> str:
    """A processed, ready listing with one photo on disk. Returns its id."""
    db = factory()
    seller = Seller(id=SELLER_ID, firebase_uid="fb-ondc", phone_number="+919800000001", language="hi")
    listing = Listing(
        id=uuid.uuid4(),
        seller_id=SELLER_ID,
        client_item_id=f"capture-{uuid.uuid4()}",
        state=ListingState.ready,
    )
    photo_dir = media_root / str(listing.id)
    photo_dir.mkdir()
    Image.new("RGB", (32, 32), "white").save(photo_dir / "photo.jpg")
    media = Media(
        id=uuid.uuid4(),
        listing_id=listing.id,
        media_type=MediaType.image,
        original_filename="photo.jpg",
        storage_path=f"{listing.id}/photo.jpg",
        mime_type="image/jpeg",
        file_size_bytes=1,
    )
    fields = dict(
        title="Terracotta Water Pot",
        description="A water pot shaped by hand from river clay.",
        material="River clay",
        quantity=4,
        price_in_paise=45000,
        attributes={"category": "pottery", "short_description": "A handmade clay pot."},
    )
    fields.update(result_fields)
    result = ListingResult(listing_id=listing.id, **fields)
    if db.query(Seller).filter(Seller.id == SELLER_ID).first() is None:
        db.add(seller)
    db.add_all([listing, media, result])
    db.commit()
    listing_id = str(listing.id)
    db.close()
    return listing_id


def _result(factory, listing_id: str) -> ListingResult:
    db = factory()
    row = db.query(ListingResult).filter(ListingResult.listing_id == uuid.UUID(listing_id)).one()
    db.close()
    return row


# --------------------------------------------------------------------------
# Mapping
# --------------------------------------------------------------------------


def test_a_complete_listing_maps_to_a_valid_ondc_item(session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root)
    db = session_factory()
    listing = db.query(Listing).filter(Listing.id == uuid.UUID(listing_id)).one()

    item, domain = item_for_listing(listing)

    assert domain == "ONDC:RET16"
    assert item["id"] == listing_id
    assert item["category_id"] == "Home Decor"
    assert item["price"] == {"currency": "INR", "value": "450.0", "maximum_value": "450.0"}
    assert item["quantity"]["available"]["count"] == "4"
    assert item["descriptor"]["images"][0].startswith(f"https://share.example/p/{listing_id}/images/")
    assert item["descriptor"]["short_desc"] == "A handmade clay pot."
    db.close()


def test_a_listing_without_a_category_is_not_sent(session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root, attributes={})
    db = session_factory()
    listing = db.query(Listing).filter(Listing.id == uuid.UUID(listing_id)).one()
    with pytest.raises(OndcNotReady, match="category"):
        item_for_listing(listing)
    db.close()


# --------------------------------------------------------------------------
# Publishing and the lifecycle after it
# --------------------------------------------------------------------------


def test_publishing_pushes_to_ondc_and_returns_the_share_page(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root)

    response = client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)

    assert response.status_code == 200
    assert response.json()["preview_url"] == f"https://share.example/p/{listing_id}"
    ondc = _result(session_factory, listing_id).attributes["ondc"]
    assert ondc["status"] == "published"
    assert ondc["action"] == "publish"
    assert ondc["catalog_id"].startswith("mock-cat-")
    assert ondc["domain"] == "ONDC:RET16"

    with open(media_root / "exports" / "ondc_listings.csv", newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    assert [row["id"] for row in rows] == [listing_id]

    listing = client.get(f"/api/v1/listings/{listing_id}", headers=AUTH).json()
    assert listing["preview_url"] == f"https://share.example/p/{listing_id}"


def test_a_listing_ondc_cannot_take_still_publishes_in_the_app(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root, attributes={})

    response = client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)

    assert response.status_code == 200
    assert response.json()["state"] == "published"
    ondc = _result(session_factory, listing_id).attributes["ondc"]
    assert ondc["status"] == "not_ready"
    assert "category" in ondc["reason"]


def test_a_price_change_republishes_and_zero_stock_delists(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root)
    client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)

    client.patch(f"/api/v1/listings/{listing_id}", json={"price": 40000}, headers=AUTH)
    ondc = _result(session_factory, listing_id).attributes["ondc"]
    assert ondc["action"] == "republish"
    assert ondc["item"]["price"]["value"] == "400.0"

    client.patch(f"/api/v1/listings/{listing_id}", json={"quantity": 0}, headers=AUTH)
    ondc = _result(session_factory, listing_id).attributes["ondc"]
    assert ondc["action"] == "delist"
    assert ondc["status"] == "delisted"

    client.patch(f"/api/v1/listings/{listing_id}", json={"quantity": 3}, headers=AUTH)
    ondc = _result(session_factory, listing_id).attributes["ondc"]
    assert ondc["action"] == "publish"
    assert ondc["status"] == "published"


def test_editing_an_unpublished_listing_does_not_touch_ondc(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root)
    client.patch(f"/api/v1/listings/{listing_id}", json={"price": 40000}, headers=AUTH)
    assert "ondc" not in (_result(session_factory, listing_id).attributes or {})


# --------------------------------------------------------------------------
# Share page
# --------------------------------------------------------------------------


def test_the_share_page_is_public_once_published(client, session_factory, media_root):
    listing_id = _ready_listing(
        session_factory,
        media_root,
        attributes={"category": "pottery", "long_description_hi": "हाथ से बना घड़ा।"},
    )
    assert client.get(f"/p/{listing_id}").status_code == 404

    client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)
    page = client.get(f"/p/{listing_id}")

    assert page.status_code == 200
    assert "Terracotta Water Pot" in page.text
    assert "₹450.0" in page.text
    assert "हाथ से बना घड़ा।" in page.text

    image_url = _result(session_factory, listing_id).attributes["ondc"]["item"]["descriptor"]["images"][0]
    image = client.get(image_url.replace("https://share.example", ""))
    assert image.status_code == 200
    assert image.headers["content-type"] == "image/jpeg"


def test_the_share_page_escapes_what_it_shows(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root, title="<script>alert(1)</script>")
    client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)

    page = client.get(f"/p/{listing_id}")

    assert "<script>alert(1)</script>" not in page.text
    assert "&lt;script&gt;" in page.text


def test_unknown_or_malformed_share_links_are_404(client, session_factory, media_root):
    assert client.get("/p/not-a-uuid").status_code == 404
    assert client.get(f"/p/{uuid.uuid4()}").status_code == 404
    listing_id = _ready_listing(session_factory, media_root)
    client.post(f"/api/v1/listings/{listing_id}/publish", headers=AUTH)
    assert client.get(f"/p/{listing_id}/images/{uuid.uuid4()}").status_code == 404


# --------------------------------------------------------------------------
# Suggested additions
# --------------------------------------------------------------------------


def test_an_addition_joins_the_description_only_after_a_yes(client, session_factory, media_root):
    listing_id = _ready_listing(session_factory, media_root)
    db = session_factory()
    addition = Suggestion(
        listing_id=uuid.UUID(listing_id),
        field="addition:occasion",
        value="It makes a good gift.",
        reason="Should I say it makes a good gift?",
    )
    db.add(addition)
    db.commit()
    suggestion_id = str(addition.id)
    db.close()

    listing = client.get(f"/api/v1/listings/{listing_id}", headers=AUTH).json()
    offered = [s for s in listing["suggestions"] if s["id"] == suggestion_id][0]
    assert offered["field"] == "addition"
    assert offered["spoken_prompt"] == "Should I say it makes a good gift?"
    assert "good gift" not in listing["description"]

    client.post(
        f"/api/v1/listings/{listing_id}/suggestions/{suggestion_id}/approval",
        json={"approved": True},
        headers=AUTH,
    )
    listing = client.get(f"/api/v1/listings/{listing_id}", headers=AUTH).json()
    assert listing["description"] == "A water pot shaped by hand from river clay. It makes a good gift."
