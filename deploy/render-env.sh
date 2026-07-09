#!/usr/bin/env bash
# Render deploy/env.template using environment variables (works on macOS without gettext).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/env.template"
OUTPUT="${1:-${SCRIPT_DIR}/../.env.production}"

required_vars=(
  POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB APP_DEBUG
  LLM_PROVIDER ANTHROPIC_MODEL ANTHROPIC_API_KEY
  SIMPLEFIN_ACCESS_URL DBT_TARGET
)

for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required variable: ${var}" >&2
    exit 1
  fi
done

python3 - "${TEMPLATE}" "${OUTPUT}" << 'PY'
import os
import sys

template_path, output_path = sys.argv[1], sys.argv[2]
text = open(template_path).read()
# Replace ${VAR} placeholders only (not $VAR without braces)
for key, value in os.environ.items():
    text = text.replace("${" + key + "}", value)
open(output_path, "w").write(text)
PY

echo "Wrote ${OUTPUT}"
