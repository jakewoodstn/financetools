# Phase 0 / 0b — Complete

## Created files

| Path | Purpose |
|---|---|
| [local-dev.md](local-dev.md) | Local startup and test instructions |
| [github-setup.md](github-setup.md) | GitHub Environments, secrets inventory, branch protection |
| `.github/workflows/ci.yml` | PR/push CI: Postgres service, alembic, pytest |
| `.github/workflows/deploy.yml` | Build + production deploy skeleton |
| `deploy/env.template` | Secret placeholder template |
| `deploy/render-env.sh` | Renders template (Python; no envsubst required) |
| `deploy/docker-compose.prod.yml` | Production compose stub |
| `finance_app/Dockerfile` | App container for production |

## Verified locally

- Colima + Postgres running
- `alembic upgrade head` OK
- `pytest` — 2 passed
- 1000 sample transactions in Postgres
- `deploy/render-env.sh` renders valid `.env`

## Your manual steps (Phase 0b)

1. GitHub → Settings → Environments → create `production` (and optional `ci`)
2. Add secrets/variables per [github-setup.md](github-setup.md)
3. Settings → Branches → require **Test** status check on `main`
4. Push to GitHub to confirm CI runs on Actions tab

Deploy workflow skips env render until `POSTGRES_PASSWORD` is set in `production` environment — expected until you configure secrets.
