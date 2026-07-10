"""Tagged events and transaction tag links.

Revision ID: 003_events_and_tags
Revises: 002_plural_names_and_ids
Create Date: 2026-07-09
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "003_events_and_tags"
down_revision: Union[str, Sequence[str], None] = "002_plural_names_and_ids"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "tagged_events",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("tag", sa.String(length=200), nullable=False),
        sa.Column("description", sa.String(length=1000), nullable=True),
        sa.Column("effective_date", sa.Date(), nullable=True),
        sa.Column("retired_date", sa.Date(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "transaction_tagged_events",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("bank_transaction_id", sa.BigInteger(), nullable=False),
        sa.Column("tagged_event_id", sa.Integer(), nullable=False),
        sa.Column("category_split_detail_id", sa.BigInteger(), nullable=True),
        sa.Column("tagged_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["bank_transaction_id"], ["bank_transactions.id"]),
        sa.ForeignKeyConstraint(["category_split_detail_id"], ["category_split_details.id"]),
        sa.ForeignKeyConstraint(["tagged_event_id"], ["tagged_events.id"]),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade() -> None:
    op.drop_table("transaction_tagged_events")
    op.drop_table("tagged_events")
