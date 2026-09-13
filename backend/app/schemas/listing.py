from typing import List, Optional
from pydantic import BaseModel, ConfigDict
from app.schemas.enums import ListingState


class ListingCreateRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    client_item_id: str


class ListingResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    id: str
    client_item_id: str
    state: ListingState


class ListingListResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    items: List[ListingResponse]


class ListingStatusResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    listing_id: str
    state: ListingState


class ListingAttentionResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    listing_id: str
    needs_attention: bool
    question: Optional[str] = None
    field: Optional[str] = None


class ListingReadbackResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    listing_id: str
    language: str
    title: str
    description: str
    price: Optional[float] = None
    audio_url: Optional[str] = None
