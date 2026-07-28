"""Unify observed balances: one row per account/date; drop anchors.

Revision ID: 013_observed_computed
Revises: 012_balance_tracking
Create Date: 2026-07-25
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "013_observed_computed"
down_revision: Union[str, None] = "012_balance_tracking"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Fold any anchor that has no observation on that day into observations.
    op.execute(
        """
        INSERT INTO balance_observations (account_id, as_of_date, amount, source, observed_at)
        SELECT a.account_id, a.as_of_date, a.amount, 'legacy', now()
        FROM balance_anchors a
        WHERE NOT EXISTS (
            SELECT 1
            FROM balance_observations o
            WHERE o.account_id = a.account_id
              AND o.as_of_date = a.as_of_date
        )
        """
    )

    # Keep one observation per account/date (latest observed_at, then highest id).
    op.execute(
        """
        DELETE FROM balance_observations o
        USING balance_observations newer
        WHERE o.account_id = newer.account_id
          AND o.as_of_date = newer.as_of_date
          AND (
              o.observed_at < newer.observed_at
              OR (o.observed_at = newer.observed_at AND o.id < newer.id)
          )
        """
    )

    op.drop_constraint(
        "uq_balance_observations_account_date_source",
        "balance_observations",
        type_="unique",
    )
    op.drop_column("balance_observations", "source")
    op.create_unique_constraint(
        "uq_balance_observations_account_date",
        "balance_observations",
        ["account_id", "as_of_date"],
    )

    op.drop_index("ix_balance_anchors_account_as_of", table_name="balance_anchors")
    op.drop_table("balance_anchors")


def downgrade() -> None:
    op.create_table(
        "balance_anchors",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("as_of_date", sa.Date(), nullable=False),
        sa.Column("amount", sa.Numeric(19, 4), nullable=False),
        sa.Column("note", sa.String(length=500), nullable=True),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "account_id",
            "as_of_date",
            name="uq_balance_anchors_account_date",
        ),
    )
    op.create_index(
        "ix_balance_anchors_account_as_of",
        "balance_anchors",
        ["account_id", "as_of_date"],
    )

    op.drop_constraint(
        "uq_balance_observations_account_date",
        "balance_observations",
        type_="unique",
    )
    op.add_column(
        "balance_observations",
        sa.Column("source", sa.String(length=50), nullable=False, server_default="observed"),
    )
    op.create_unique_constraint(
        "uq_balance_observations_account_date_source",
        "balance_observations",
        ["account_id", "as_of_date", "source"],
    )
    op.alter_column("balance_observations", "source", server_default=None)
