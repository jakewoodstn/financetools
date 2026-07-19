"""Balance observations, anchors, and regenerable daily_balances.

Revision ID: 012_balance_tracking
Revises: 011_last_import_batch_id
Create Date: 2026-07-18
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "012_balance_tracking"
down_revision: Union[str, None] = "011_last_import_batch_id"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "balance_observations",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("as_of_date", sa.Date(), nullable=False),
        sa.Column("amount", sa.Numeric(19, 4), nullable=False),
        sa.Column("source", sa.String(length=50), nullable=False),
        sa.Column("observed_at", sa.DateTime(), server_default="now()", nullable=False),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "account_id",
            "as_of_date",
            "source",
            name="uq_balance_observations_account_date_source",
        ),
    )
    op.create_index(
        "ix_balance_observations_account_as_of",
        "balance_observations",
        ["account_id", "as_of_date"],
    )

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

    op.create_table(
        "daily_balances",
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("measurement_date", sa.Date(), nullable=False),
        sa.Column("amount", sa.Numeric(19, 4), nullable=False),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.PrimaryKeyConstraint("account_id", "measurement_date"),
    )


def downgrade() -> None:
    op.drop_table("daily_balances")
    op.drop_index("ix_balance_anchors_account_as_of", table_name="balance_anchors")
    op.drop_table("balance_anchors")
    op.drop_index("ix_balance_observations_account_as_of", table_name="balance_observations")
    op.drop_table("balance_observations")
