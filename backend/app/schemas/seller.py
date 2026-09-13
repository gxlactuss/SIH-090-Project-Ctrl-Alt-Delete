from pydantic import BaseModel, ConfigDict


class SellerResponse(BaseModel):
    model_config = ConfigDict(extra="forbid")

    id: str
    name: str
    language: str
    cluster: str
    ondc_seller_id: str
