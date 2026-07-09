# GitHub Environments and secrets

GitHub is the **source of truth** for production configuration. Do not edit `.env` on EC2 by hand — update GitHub and re-run the deploy workflow.

## Create environments

Repo → Settings → Environments → New environment:

| Environment | Purpose |
|---|---|
| `ci` | Optional secrets for integration tests (PR workflow uses inline Postgres; usually empty) |
| `production` | Deploy target; all runtime secrets |
| `migration` | Manual SQL Server migration only; retire after cutover |

## Production secrets

Settings → Environments → `production` → Add secret:

| Secret | Description |
|---|---|
| `POSTGRES_PASSWORD` | Postgres superuser/app password |
| `ANTHROPIC_API_KEY` | Anthropic API key (LLM provider) |
| `SIMPLEFIN_ACCESS_URL` | Claimed SimpleFIN access URL (Phase 3+) |
| `EC2_HOST` | Production host IP or DNS |
| `EC2_SSH_PRIVATE_KEY` | SSH key for deploy (or use SSM-only in Phase 9) |
| `AWS_ROLE_ARN` | IAM role for OIDC (`configure-aws-credentials`) |

## Production variables (non-secret)

Settings → Environments → `production` → Add variable:

| Variable | Example |
|---|---|
| `POSTGRES_USER` | `finance` |
| `POSTGRES_DB` | `finances` |
| `APP_DEBUG` | `false` |
| `LLM_PROVIDER` | `anthropic` |
| `ANTHROPIC_MODEL` | `claude-sonnet-4-20250514` |
| `DBT_TARGET` | `prod` |
| `EC2_APP_DIR` | `/opt/finance` |

`DATABASE_URL` is rendered at deploy time from user/password/db — see [`deploy/env.template`](../deploy/env.template).

## Migration environment (temporary)

For one-off full SQL Server → Postgres migration:

| Secret | Description |
|---|---|
| `MSSQL_HOST` | RDS hostname |
| `MSSQL_USER` | Read-only SQL login |
| `MSSQL_PASSWORD` | SQL password |

Remove after Phase 10 cutover.

## Branch protection (recommended)

Settings → Branches → Add rule for `main`:

- Require status check: **CI** (from `.github/workflows/ci.yml`)
- Require pull request before merging

## AWS OIDC (Phase 9)

Configure GitHub as an OIDC identity provider in IAM so deploy workflows assume a role without long-lived AWS access keys. Steps documented in Phase 9 CDK work.
