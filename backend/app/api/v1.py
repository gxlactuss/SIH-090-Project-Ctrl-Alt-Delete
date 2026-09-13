from fastapi import APIRouter
from app.api.routes.seller import router as seller_router
from app.api.routes.listings import router as listings_router
from app.api.routes.media import router as media_router

api_v1_router = APIRouter(prefix="/api/v1")

api_v1_router.include_router(seller_router)
api_v1_router.include_router(listings_router)
api_v1_router.include_router(media_router)
