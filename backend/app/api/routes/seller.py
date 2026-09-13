from fastapi import APIRouter, status
from app.schemas.seller import SellerResponse

router = APIRouter(prefix="/seller", tags=["Seller"])


@router.get(
    "",
    response_model=SellerResponse,
    status_code=status.HTTP_200_OK,
    summary="Get Seller Profile",
    description="Return the currently configured seller profile.",
)
def get_seller() -> SellerResponse:
    return SellerResponse(
        id="seller-001",
        name="Artisan Radha Devi",
        language="hi",
        cluster="Madhubani Cluster",
        ondc_seller_id="ONDC-SELL-IND-9876",
    )
