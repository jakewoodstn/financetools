"""Stamp ledger rows with the import batch that last touched them.

Revision ID: 011_last_import_batch_id
Revises: 010_transient_raw_staging
Create Date: 2026-07-18
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "011_last_import_batch_id"
down_revision: Union[str, None] = "010_transient_raw_staging"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        "bank_transactions",
        sa.Column("last_import_batch_id", sa.Integer(), nullable=True),
    )
    op.create_foreign_key(
        "fk_bank_transactions_last_import_batch_id",
        "bank_transactions",
        "import_batches",
        ["last_import_batch_id"],
        ["id"],
    )
    op.create_index(
        "ix_bank_transactions_last_import_batch_id",
        "bank_transactions",
        ["last_import_batch_id"],
    )


def downgrade() -> None:
    op.drop_index("ix_bank_transactions_last_import_batch_id", table_name="bank_transactions")
    op.drop_constraint(
        "fk_bank_transactions_last_import_batch_id",
        "bank_transactions",
        type_="foreignkey",
    )
    op.drop_column("bank_transactions", "last_import_batch_id")
