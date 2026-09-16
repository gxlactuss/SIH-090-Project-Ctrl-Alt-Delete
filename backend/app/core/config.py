from typing import List, Union
from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )

    PROJECT_NAME: str = "Listing Factory API"
    VERSION: str = "0.1.0"
    ENVIRONMENT: str = "development"

    # PostgreSQL Database URL
    DATABASE_URL: str = "postgresql+psycopg2://postgres:postgres@localhost:5432/listing_factory"

    # JWT Authentication configuration
    JWT_SECRET: str = "replace-with-a-secure-random-secret-key-in-production"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # Firebase Authentication configuration
    FIREBASE_SERVICE_ACCOUNT_JSON: Union[str, None] = None
    FIREBASE_SERVICE_ACCOUNT_PATH: Union[str, None] = None

    # Media storage configuration
    MEDIA_STORAGE_DIR: str = "./media"
    MAX_MEDIA_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10 MB in bytes

    # CORS origins
    CORS_ORIGINS: Union[List[str], str] = ["*"]

    @field_validator("CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> List[str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",") if i.strip()]
        return v


settings = Settings()
