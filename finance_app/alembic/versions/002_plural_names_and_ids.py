"""Plural table names and id primary keys.

Revision ID: 002_plural_names_and_ids
Revises: 001_initial
Create Date: 2026-07-09
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "002_plural_names_and_ids"
down_revision: Union[str, Sequence[str], None] = "001_initial"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Sample-data-only stage: drop 001 tables and rebuild with target naming.
    op.drop_table("category_split_detail")
    op.drop_table("bank_transaction")
    op.drop_table("transaction_account")
    op.drop_table("spending_category")
    op.drop_table("spending_category_group")
    op.drop_table("account")

    op.create_table(
        "accounts",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("account_name", sa.String(length=50), nullable=True),
        sa.Column("created_at", sa.Date(), nullable=True),
        sa.Column("closed_on", sa.Date(), nullable=True),
        sa.Column("import_transactions", sa.SmallInteger(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "spending_category_groups",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("group_name", sa.String(length=200), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "spending_categories",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("category_name", sa.String(length=200), nullable=True),
        sa.Column("spending_category_group_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["spending_category_group_id"], ["spending_category_groups.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "transaction_accounts",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=255), nullable=False),
        sa.Column("account_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("name"),
    )
    op.create_table(
        "bank_transactions",
        sa.Column("id", sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column("external_id", sa.BigInteger(), nullable=False),
        sa.Column("transaction_date", sa.Date(), nullable=True),
        sa.Column("loaded_date", sa.DateTime(), nullable=True),
        sa.Column("description", sa.String(length=1000), nullable=True),
        sa.Column("import_category", sa.String(length=100), nullable=True),
        sa.Column("amount", sa.Numeric(precision=19, scale=4), nullable=True),
        sa.Column("spending_category_id", sa.Integer(), nullable=True),
        sa.Column("orig_description", sa.String(length=1000), nullable=True),
        sa.Column("category_status", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("bank_orig_description", sa.String(length=1000), nullable=True),
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("accounting_date", sa.Date(), nullable=True),
        sa.ForeignKeyConstraint(["account_id"], ["accounts.id"]),
        sa.ForeignKeyConstraint(["spending_category_id"], ["spending_categories.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("external_id"),
    )
    op.create_table(
        "category_split_details",
        sa.Column("id", sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column("external_id", sa.BigInteger(), nullable=False),
        sa.Column("bank_transaction_id", sa.BigInteger(), nullable=False),
        sa.Column("spending_category_id", sa.Integer(), nullable=True),
        sa.Column("split_amount", sa.Numeric(precision=19, scale=4), nullable=True),
        sa.ForeignKeyConstraint(["bank_transaction_id"], ["bank_transactions.id"]),
        sa.ForeignKeyConstraint(["spending_category_id"], ["spending_categories.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("external_id"),
    )


def downgrade() -> None:
    op.drop_table("category_split_details")
    op.drop_table("bank_transactions")
    op.drop_table("transaction_accounts")
    op.drop_table("spending_categories")
    op.drop_table("spending_category_groups")
    op.drop_table("accounts")

    op.create_table(
        "account",
        sa.Column("account_id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("account_name", sa.String(length=50), nullable=True),
        sa.Column("created_at", sa.Date(), nullable=True),
        sa.Column("closed_on", sa.Date(), nullable=True),
        sa.Column("import_transactions", sa.SmallInteger(), nullable=True),
        sa.PrimaryKeyConstraint("account_id"),
    )
    op.create_table(
        "spending_category_group",
        sa.Column("group_id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("group_name", sa.String(length=200), nullable=True),
        sa.PrimaryKeyConstraint("group_id"),
    )
    op.create_table(
        "spending_category",
        sa.Column("category_id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("category_name", sa.String(length=200), nullable=True),
        sa.Column("group_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["group_id"], ["spending_category_group.group_id"]),
        sa.PrimaryKeyConstraint("category_id"),
    )
    op.create_table(
        "transaction_account",
        sa.Column("transaction_account_name", sa.String(length=255), nullable=False),
        sa.Column("account_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(["account_id"], ["account.account_id"]),
        sa.PrimaryKeyConstraint("transaction_account_name"),
    )
    op.create_table(
        "bank_transaction",
        sa.Column("transaction_id", sa.BigInteger(), autoincrement=False, nullable=False),
        sa.Column("transaction_date", sa.Date(), nullable=True),
        sa.Column("loaded_date", sa.DateTime(), nullable=True),
        sa.Column("description", sa.String(length=1000), nullable=True),
        sa.Column("category", sa.String(length=100), nullable=True),
        sa.Column("amount", sa.Numeric(precision=19, scale=4), nullable=True),
        sa.Column("account", sa.String(length=100), nullable=True),
        sa.Column("category_id", sa.Integer(), nullable=True),
        sa.Column("orig_description", sa.String(length=1000), nullable=True),
        sa.Column("category_status", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("bank_orig_description", sa.String(length=1000), nullable=True),
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("accounting_date", sa.Date(), nullable=True),
        sa.ForeignKeyConstraint(["category_id"], ["spending_category.category_id"]),
        sa.ForeignKeyConstraint(["account_id"], ["account.account_id"]),
        sa.PrimaryKeyConstraint("transaction_id"),
    )
    op.create_table(
        "category_split_detail",
        sa.Column("split_transaction_id", sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column("parent_transaction_id", sa.BigInteger(), nullable=True),
        sa.Column("category_id", sa.Integer(), nullable=True),
        sa.Column("split_amount", sa.Numeric(precision=19, scale=4), nullable=True),
        sa.ForeignKeyConstraint(["category_id"], ["spending_category.category_id"]),
        sa.ForeignKeyConstraint(["parent_transaction_id"], ["bank_transaction.transaction_id"]),
        sa.PrimaryKeyConstraint("split_transaction_id"),
    )
