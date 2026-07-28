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
| `007_enable_account_4_import` | Enable transaction import for account 4 |
| `008_raw_source_external_id` | Provider identity on pending raw rows |
| `009_raw_promotion_review` | Hold ambiguous promotion rows for review |
| `010_transient_raw_staging` | Persist provider identity on ledger rows and clear successful staging rows |
| `011_last_import_batch_id` | Stamp ledger rows with the import batch that last touched them |
| `012_balance_tracking` | Balance observations and regenerable daily_balances |
| `013_observed_computed` | One observed balance per account/date; drop anchors/source |

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
- **balance_observations** — sparse documented end-of-day balances (observed truth; one per account/date)
- **daily_balances** — disposable/derived daily series from the latest prior observation + intervening transactions; safe to truncate and rebuild

## Local commands

```bash
cd finance_app
docker compose up -d
uv run alembic upgrade head
uv run alembic current   # should show 012_balance_tracking
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
| Money Market Savings Account (2395) | 4 | Ally Bank - Tax Withholding (`import_transactions=1`) |

Stored in `transaction_accounts.name` (upserted on each migration run).

CI loads `tools/fixtures/sample/data.sql` and validates against `tools/fixtures/sample/manifest.json` on every push.

### SimpleFIN ingest (Phase 3)

**Stage** — fetch from Bridge into `raw_transactions`:

```bash
cd finance_app
uv run python scripts/stage_simplefin.py          # Bridge default window
uv run python scripts/stage_simplefin.py --days 30 --promote
uv run python scripts/stage_simplefin.py --account 3 --account 4 --days 30
```

**Promote** — copy unstaged raw rows into `bank_transactions` (accounts where `import_transactions=1`):

```bash
uv run python scripts/promote_staging.py
uv run python scripts/promote_staging.py --account 4
```

The `/import` UI stages and promotes per account in one step.

**CSV fallback** — bank direct downloads with header auto-mapping:

```bash
uv run python scripts/import_csv.py --account 1 ~/Downloads/transactions.csv
uv run python scripts/import_csv.py --account 2 file.csv --replace --col-date "Transaction Date"
```

Bank exports often include title and footer lines; the importer scans for the real header row and stops before summary/footer text.

#### Idempotency

| Layer | Key | Behavior |
| --- | --- | --- |
| Staging | `dedupe_hash` (account, date, amount, description) | indexed comparison key; not unique because identical same-day transactions are valid |
| Staging | `source_external_id` (SimpleFIN txn id) | unique partial index prevents duplicate provider rows while pending |
| Ledger | `bank_transactions.source_external_id` | permanent SimpleFIN identity and idempotency key |
| Ledger | `bank_transactions.last_import_batch_id` | batch that last inserted or linked the row (powers “Latest import” preview) |
| Promotion | `source_external_id` or ledger 4-tuple | link to existing `bank_transactions` row; ambiguous matches → `needs_review` holding |
| Promotion | `external_id` on insert | `ON CONFLICT DO NOTHING`; SimpleFIN ids map to `2_000_000_000_000+` range |

`raw_transactions` is a transient working table, matching the legacy
`bankTransactionLoad` behavior. Successfully inserted or linked rows are removed
after promotion. Rows that match multiple `bank_transactions` on the same ledger
key remain in `raw_transactions` with `promotion_status=needs_review` and a
`promotion_note` explaining the conflict. `import_batches` permanently records
the source, account, import time, filename, and final batch status. The import
UI previews the latest batch via `bank_transactions.last_import_batch_id`.

### Balance tracking

Observed balances are sparse end-of-day truths. Computed (implied) daily balances
are rebuilt set-based from the latest *prior* observation:

```text
balance(B) = observed(A).amount + SUM(txns where A < D <= B)
```

where A is the latest observation with `as_of_date < B`. On an observation day
the computed value can differ from the observed amount — that gap is drift.
After that day, later computed balances reseed from the new observation.
The first observation day is seeded as computed = observed.

Rebuild after imports:

```bash
cd finance_app
uv run python scripts/recompute_balances.py
uv run python scripts/recompute_balances.py --account 1 --drift
```

SimpleFIN imports record a `balance_observations` row **only when the import
`end_date` is today**, then compare observed vs computed-from-prior on that date
and show hold/drift on the import result panel. The import sidebar shows each
account’s latest observed balance date and amount. Charts live at `/balances`
and label series only as **observed** or **computed**.

Full remigration copies legacy `DailyBalance` into `balance_observations` and
rebuilds `daily_balances` for acceptance drift checks.
