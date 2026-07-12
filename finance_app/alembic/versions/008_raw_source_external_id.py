"""Add source_external_id to raw_transactions for provider-level idempotency.

Revision ID: 008_raw_source_external_id
Revises: 007_enable_account_4_import
Create Date: 2026-07-11
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "008_raw_source_external_id"
down_revision: Union[str, None] = "007_enable_account_4_import"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("raw_transactions", sa.Column("source_external_id", sa.String(length=200), nullable=True))
    op.create_index(
        "uq_raw_transactions_source_external_id",
        "raw_transactions",
        ["source_external_id"],
        unique=True,
        postgresql_where=sa.text("source_external_id IS NOT NULL"),
    )


def downgrade() -> None:
    op.drop_index("uq_raw_transactions_source_external_id", table_name="raw_transactions")
    op.drop_column("raw_transactions", "source_external_id")
