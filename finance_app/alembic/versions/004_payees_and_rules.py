"""Payees, aliases, category rules and suggestions.

Revision ID: 004_payees_and_rules
Revises: 003_events_and_tags
Create Date: 2026-07-09
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "004_payees_and_rules"
down_revision: Union[str, Sequence[str], None] = "003_events_and_tags"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "payees",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("canonical_name", sa.String(length=500), nullable=False),
        sa.Column("created_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "payee_aliases",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("payee_id", sa.Integer(), nullable=False),
        sa.Column("raw_text", sa.String(length=1000), nullable=False),
        sa.Column("source", sa.String(length=50), nullable=False),
        sa.ForeignKeyConstraint(["payee_id"], ["payees.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "category_rules",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("payee_id", sa.Integer(), nullable=False),
        sa.Column("spending_category_id", sa.Integer(), nullable=False),
        sa.Column("source", sa.String(length=50), nullable=False),
        sa.Column("created_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["payee_id"], ["payees.id"]),
        sa.ForeignKeyConstraint(["spending_category_id"], ["spending_categories.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "category_suggestions",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("bank_transaction_id", sa.BigInteger(), nullable=False),
        sa.Column("spending_category_id", sa.Integer(), nullable=False),
        sa.Column("confidence", sa.Numeric(precision=5, scale=4), nullable=True),
        sa.Column("source", sa.String(length=50), nullable=False),
        sa.Column("created_at", sa.DateTime(), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["bank_transaction_id"], ["bank_transactions.id"]),
        sa.ForeignKeyConstraint(["spending_category_id"], ["spending_categories.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.add_column("bank_transactions", sa.Column("payee_id", sa.Integer(), nullable=True))
    op.create_foreign_key(
        "fk_bank_transactions_payee_id",
        "bank_transactions",
        "payees",
        ["payee_id"],
        ["id"],
    )


def downgrade() -> None:
    op.drop_constraint("fk_bank_transactions_payee_id", "bank_transactions", type_="foreignkey")
    op.drop_column("bank_transactions", "payee_id")
    op.drop_table("category_suggestions")
    op.drop_table("category_rules")
    op.drop_table("payee_aliases")
    op.drop_table("payees")
