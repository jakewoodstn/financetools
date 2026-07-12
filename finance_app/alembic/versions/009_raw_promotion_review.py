"""Add promotion review holding fields on raw_transactions.

Revision ID: 009_raw_promotion_review
Revises: 008_raw_source_external_id
Create Date: 2026-07-12
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "009_raw_promotion_review"
down_revision: Union[str, None] = "008_raw_source_external_id"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("raw_transactions", sa.Column("promotion_status", sa.String(length=50), nullable=True))
    op.add_column("raw_transactions", sa.Column("promotion_note", sa.Text(), nullable=True))
    op.create_index(
        "ix_raw_transactions_promotion_review",
        "raw_transactions",
        ["account_id", "promotion_status"],
        postgresql_where=sa.text("promotion_status = 'needs_review'"),
    )


def downgrade() -> None:
    op.drop_index("ix_raw_transactions_promotion_review", table_name="raw_transactions")
    op.drop_column("raw_transactions", "promotion_note")
    op.drop_column("raw_transactions", "promotion_status")
