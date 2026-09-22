"""Drop the craft form, origin and story fields.

The voice note no longer asks for them, so nothing writes or reads these
columns any more.

Revision ID: 0008_drop_craft_story_fields
Revises: 0007_listing_origin
Create Date: 2026-09-22 12:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "0008_drop_craft_story_fields"
down_revision: Union[str, None] = "0007_listing_origin"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

_COLUMNS = ("technique", "origin", "craft_type", "story_summary")


def upgrade() -> None:
    with op.batch_alter_table("listing_results") as batch_op:
        for column in _COLUMNS:
            batch_op.drop_column(column)


def downgrade() -> None:
    with op.batch_alter_table("listing_results") as batch_op:
        for column in _COLUMNS:
            batch_op.add_column(sa.Column(column, sa.Text(), nullable=True))
