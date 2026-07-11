"""Enable SimpleFIN import for Ally Tax Withholding (account 4).

Revision ID: 007_enable_account_4_import
Revises: 006_transfers_and_cleanup
Create Date: 2026-07-11
"""

from typing import Sequence, Union

from alembic import op

revision: str = "007_enable_account_4_import"
down_revision: Union[str, None] = "006_transfers_and_cleanup"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("UPDATE accounts SET import_transactions = 1 WHERE id = 4")


def downgrade() -> None:
    op.execute("UPDATE accounts SET import_transactions = 0 WHERE id = 4")
