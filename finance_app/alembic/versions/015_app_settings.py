"""Add app_settings key-value store for UI theme.

Revision ID: 015_app_settings
Revises: 014_account_color
Create Date: 2026-08-02
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "015_app_settings"
down_revision: Union[str, None] = "014_account_color"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "app_settings",
        sa.Column("key", sa.String(length=64), primary_key=True),
        sa.Column("value", sa.String(length=255), nullable=False),
    )
    op.execute(
        sa.text("INSERT INTO app_settings (key, value) VALUES ('ui_theme', 'default')")
    )


def downgrade() -> None:
    op.drop_table("app_settings")
