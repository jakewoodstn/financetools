"""Transfer links and query indexes.

Revision ID: 006_transfers_and_cleanup
Revises: 005_ingest_staging
Create Date: 2026-07-09
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "006_transfers_and_cleanup"
down_revision: Union[str, Sequence[str], None] = "005_ingest_staging"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "transfer_links",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("outbound_bank_transaction_id", sa.BigInteger(), nullable=False),
        sa.Column("inbound_bank_transaction_id", sa.BigInteger(), nullable=False),
        sa.Column("linked_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["inbound_bank_transaction_id"], ["bank_transactions.id"]),
        sa.ForeignKeyConstraint(["outbound_bank_transaction_id"], ["bank_transactions.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("inbound_bank_transaction_id"),
        sa.UniqueConstraint("outbound_bank_transaction_id"),
    )
    op.create_index(
        "ix_bank_transactions_category_status_accounting_date",
        "bank_transactions",
        ["category_status", "accounting_date"],
    )
    op.create_index("ix_bank_transactions_payee_id", "bank_transactions", ["payee_id"])
    op.create_index("ix_payee_aliases_raw_text", "payee_aliases", ["raw_text"])


def downgrade() -> None:
    op.drop_index("ix_payee_aliases_raw_text", table_name="payee_aliases")
    op.drop_index("ix_bank_transactions_payee_id", table_name="bank_transactions")
    op.drop_index("ix_bank_transactions_category_status_accounting_date", table_name="bank_transactions")
    op.drop_table("transfer_links")
