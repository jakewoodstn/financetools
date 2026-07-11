# Database schema

Operational GL tables live in the Postgres `public` schema. Alembic migrations are in `finance_app/alembic/versions/`.

## Naming conventions

| Rule | Example |
| --- | --- |
| Plural snake_case table names | `accounts`, `bank_transactions` |
| Primary key always `id` | `SERIAL` / `BIGSERIAL` |
| Foreign keys `{entity}_id` | `account_id` → `accounts.id` |
| Timestamps `_at` suffix | `created_at`, `linked_at`, `tagged_at` |

**Exception:** bank-assigned transaction IDs are stored as `external_id` on `bank_transactions` and `category_split_details`. Internal `id` values are sequence-backed and used for all foreign keys.

## Migration history

| Revision | Description |
| --- | --- |
| `001_initial` | Original 6-table prototype (singular names) |
| `002_plural_names_and_ids` | Plural tables, `id` PKs, `external_id` on transactions/splits |
| `003_events_and_tags` | `tagged_events`, `transaction_tagged_events` |
| `004_payees_and_rules` | Payee model, category rules/suggestions, `payee_id` on transactions |
| `005_ingest_staging` | `import_batches`, `raw_transactions` |
| `006_transfers_and_cleanup` | `transfer_links`, query indexes |

## Core tables

- **accounts** — financial accounts (checking, credit card, etc.)
- **spending_category_groups** / **spending_categories** — category taxonomy
- **transaction_accounts** — import source account names mapped to accounts (includes SimpleFIN Bridge names)
- **bank_transactions** — categorized ledger entries
- **category_split_details** — split allocations for a single transaction

## Extensions (Phase 1)

- **tagged_events** / **transaction_tagged_events** — event tagging (e.g. vacation, home project)
- **payees** / **payee_aliases** — normalized payee names
- **category_rules** / **category_suggestions** — payee→category memory and AI suggestions
- **import_batches** / **raw_transactions** — ingest staging before promotion to `bank_transactions`
- **transfer_links** — pairs outbound/inbound transfer transactions

## Local commands

```bash
cd finance_app
docker compose up -d
uv run alembic upgrade head
uv run alembic current   # should show 006_transfers_and_cleanup
```

## Sample data

After migrations, load data from legacy SQL Server:

```bash
cd tools
export MSSQL_HOST=... MSSQL_USER=... MSSQL_PASSWORD=...
uv run python migrate_data.py --full              # all 17k+ transactions
uv run python migrate_data.py --sample 1000 --years 4   # CI-sized sample
uv run python validate_migration.py                 # Layers 1–3 vs RDS
```

Legacy `transactionId` values land in `bank_transactions.external_id`. Split rows resolve `bank_transaction_id` via that mapping.

### SimpleFIN → accounts mapping

| SimpleFIN account name | `accounts.id` | Account |
|---|---|---|
| Adv Plus Banking- 8971 (8971) | 1 | Bank of America Checking |
| Rapid Rewards Priority (2985) | 2 | Chase Southwest Rewards Credit Card |
| Savings Account (8193) | 3 | Ally Bank - General Savings |
| Money Market Savings Account (2395) | 4 | Ally Bank - Tax Withholding |

Stored in `transaction_accounts.name` (upserted on each migration run).

CI loads `tools/fixtures/sample/data.sql` and validates against `tools/fixtures/sample/manifest.json` on every push.
