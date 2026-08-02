"""Add per-account display color.

Revision ID: 014_account_color
Revises: 013_observed_computed
Create Date: 2026-08-02
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "014_account_color"
down_revision: Union[str, None] = "013_observed_computed"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

DEFAULT_PALETTE = [
    "#1d4ed8",
    "#b45309",
    "#166534",
    "#7c3aed",
    "#be123c",
    "#0f766e",
]


def upgrade() -> None:
    op.add_column("accounts", sa.Column("color", sa.String(length=7), nullable=True))
    conn = op.get_bind()
    rows = conn.execute(sa.text("SELECT id FROM accounts ORDER BY id")).fetchall()
    for idx, (account_id,) in enumerate(rows):
        color = DEFAULT_PALETTE[idx % len(DEFAULT_PALETTE)]
        conn.execute(
            sa.text("UPDATE accounts SET color = :color WHERE id = :id"),
            {"color": color, "id": account_id},
        )


def downgrade() -> None:
    op.drop_column("accounts", "color")
