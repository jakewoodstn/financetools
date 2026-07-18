"""Make raw staging transient and persist source identity on ledger rows.

Revision ID: 010_transient_raw_staging
Revises: 009_raw_promotion_review
Create Date: 2026-07-18
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "010_transient_raw_staging"
down_revision: Union[str, None] = "009_raw_promotion_review"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        "bank_transactions",
        sa.Column("source_external_id", sa.String(length=200), nullable=True),
    )
    op.add_column(
        "import_batches",
        sa.Column("account_id", sa.Integer(), nullable=True),
    )
    op.create_foreign_key(
        "fk_import_batches_account_id",
        "import_batches",
        "accounts",
        ["account_id"],
        ["id"],
    )

    # Preserve source identity and per-account batch metadata before removing
    # successfully processed raw rows.
    op.execute(
        """
        UPDATE bank_transactions AS bank
        SET source_external_id = raw.source_external_id
        FROM raw_transactions AS raw
        WHERE raw.bank_transaction_id = bank.id
          AND raw.source_external_id IS NOT NULL
          AND bank.source_external_id IS NULL
        """
    )
    op.execute(
        """
        UPDATE import_batches AS batch
        SET account_id = grouped.account_id
        FROM (
            SELECT import_batch_id, MIN(account_id) AS account_id
            FROM raw_transactions
            GROUP BY import_batch_id
            HAVING MIN(account_id) = MAX(account_id)
        ) AS grouped
        WHERE grouped.import_batch_id = batch.id
          AND batch.account_id IS NULL
        """
    )

    op.create_index(
        "uq_bank_transactions_source_external_id",
        "bank_transactions",
        ["source_external_id"],
        unique=True,
        postgresql_where=sa.text("source_external_id IS NOT NULL"),
    )

    # A ledger tuple is not a unique transaction identity: multiple identical
    # purchases can legitimately occur on the same day.
    op.drop_constraint(
        "raw_transactions_dedupe_hash_key",
        "raw_transactions",
        type_="unique",
    )
    op.create_index(
        "ix_raw_transactions_dedupe_hash",
        "raw_transactions",
        ["dedupe_hash"],
    )

    op.execute(
        "DELETE FROM raw_transactions WHERE bank_transaction_id IS NOT NULL"
    )
    op.execute(
        """
        DELETE FROM raw_transactions AS raw
        USING accounts AS account
        WHERE raw.account_id = account.id
          AND COALESCE(account.import_transactions, 0) <> 1
          AND raw.promotion_status IS DISTINCT FROM 'needs_review'
        """
    )


def downgrade() -> None:
    # A downgrade cannot recreate duplicate raw rows that were intentionally
    # removed. It also cannot restore uniqueness if legitimate duplicate ledger
    # tuples have since been staged.
    op.drop_index("ix_raw_transactions_dedupe_hash", table_name="raw_transactions")
    op.create_unique_constraint(
        "raw_transactions_dedupe_hash_key",
        "raw_transactions",
        ["dedupe_hash"],
    )
    op.drop_index(
        "uq_bank_transactions_source_external_id",
        table_name="bank_transactions",
    )
    op.drop_constraint(
        "fk_import_batches_account_id",
        "import_batches",
        type_="foreignkey",
    )
    op.drop_column("import_batches", "account_id")
    op.drop_column("bank_transactions", "source_external_id")
