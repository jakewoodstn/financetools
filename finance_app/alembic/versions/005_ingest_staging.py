"""Import batches and raw transaction staging.

Revision ID: 005_ingest_staging
Revises: 004_payees_and_rules
Create Date: 2026-07-09
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "005_ingest_staging"
down_revision: Union[str, Sequence[str], None] = "004_payees_and_rules"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "import_batches",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("source", sa.String(length=50), nullable=False),
        sa.Column("filename", sa.String(length=500), nullable=True),
        sa.Column("imported_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.Column("status", sa.String(length=50), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "raw_transactions",
        sa.Column("id", sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column("import_batch_id", sa.Integer(), nullable=False),
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("transaction_date", sa.Date(), nullable=True),
        sa.Column("amount", sa.Numeric(precision=19, scale=4), nullable=True),
        sa.Column("bank_orig_description", sa.String(length=1000), nullable=True),
        sa.Column("import_category", sa.String(length=100), nullable=True),
        sa.Column("dedupe_hash", sa.String(length=64), nullable=False),
        sa.Column("bank_transaction_id", sa.BigInteger(), nullable=True),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.ForeignKeyConstraint(["bank_transaction_id"], ["bank_transactions.id"]),
        sa.ForeignKeyConstraint(["import_batch_id"], ["import_batches.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("dedupe_hash"),
    )


def downgrade() -> None:
    op.drop_table("raw_transactions")
    op.drop_table("import_batches")
