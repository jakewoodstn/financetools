"""Seed import-stale settings and backfill last_import_at.

Revision ID: 016_import_stale_settings
Revises: 015_app_settings
Create Date: 2026-08-02
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "016_import_stale_settings"
down_revision: Union[str, None] = "015_app_settings"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute(
        sa.text(
            """
            INSERT INTO app_settings (key, value)
            VALUES ('import_stale_days', '3')
            ON CONFLICT (key) DO NOTHING
            """
        )
    )
    op.execute(
        sa.text(
            """
            INSERT INTO app_settings (key, value)
            SELECT 'last_import_at', to_char(max(imported_at) AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
            FROM import_batches
            WHERE NOT EXISTS (
                SELECT 1 FROM app_settings WHERE key = 'last_import_at'
            )
              AND EXISTS (SELECT 1 FROM import_batches)
            """
        )
    )


def downgrade() -> None:
    op.execute(sa.text("DELETE FROM app_settings WHERE key IN ('import_stale_days', 'last_import_at')"))
