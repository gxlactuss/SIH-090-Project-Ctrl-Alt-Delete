import uuid
from datetime import datetime, timezone
from typing import TYPE_CHECKING, List, Optional

import sqlalchemy as sa
from sqlalchemy import DateTime, ForeignKey, String, UniqueConstraint, Uuid, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.schemas.enums import ListingState

if TYPE_CHECKING:
    from app.models.approval import ListingApproval
    from app.models.consent import ListingConsent
    from app.models.media import Media
    from app.models.seller import Seller
    from app.models.suggestion import Suggestion


class Listing(Base):
    """Listing entity representing a product publishing pipeline item."""

    __tablename__ = "listings"

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    seller_id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        ForeignKey("sellers.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    client_item_id: Mapped[str] = mapped_column(String(255), nullable=False)
    state: Mapped[ListingState] = mapped_column(
        sa.Enum(
            ListingState,
            name="listing_state",
            native_enum=True,
            create_constraint=True,
            values_callable=lambda x: [e.value for e in x],
        ),
        nullable=False,
        default=ListingState.queued,
        server_default=ListingState.queued.value,
        index=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        UniqueConstraint("seller_id", "client_item_id", name="uq_listings_seller_client_item"),
    )

    # Relationships
    seller: Mapped["Seller"] = relationship("Seller", back_populates="listings")
    media: Mapped[List["Media"]] = relationship(
        "Media",
        back_populates="listing",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
    suggestions: Mapped[List["Suggestion"]] = relationship(
        "Suggestion",
        back_populates="listing",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
    consent: Mapped[Optional["ListingConsent"]] = relationship(
        "ListingConsent",
        back_populates="listing",
        uselist=False,
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
    approval: Mapped[Optional["ListingApproval"]] = relationship(
        "ListingApproval",
        back_populates="listing",
        uselist=False,
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
