"""SimpleFIN Bridge HTTP client and response parsing."""

from __future__ import annotations

import base64
import json
import subprocess
from dataclasses import dataclass
from datetime import date, datetime, timedelta, timezone
from decimal import Decimal
from urllib.parse import urlencode


class SimpleFinError(Exception):
    """SimpleFIN API or configuration error."""


@dataclass(frozen=True)
class SimpleFinTransaction:
    external_id: str
    transaction_date: date
    amount: Decimal
    bank_orig_description: str
    pending: bool = False


@dataclass(frozen=True)
class SimpleFinAccount:
    external_id: str
    name: str
    balance: Decimal | None
    balance_date: date | None
    transactions: list[SimpleFinTransaction]


def validate_access_url(value: str) -> str:
    value = value.strip()
    if value.startswith("http://") or value.startswith("https://"):
        return value
    try:
        decoded = base64.b64decode(value).decode()
    except Exception as exc:
        raise SimpleFinError(f"SIMPLEFIN_ACCESS_URL is not a valid access URL or setup token: {exc}") from exc
    if "/claim/" in decoded:
        raise SimpleFinError(
            "SIMPLEFIN_ACCESS_URL is a setup token. Claim it once and store the https://user:pass@... access URL."
        )
    raise SimpleFinError("SIMPLEFIN_ACCESS_URL format not recognized.")


def _unix_to_date(value: int | float | None) -> date | None:
    if not value:
        return None
    return datetime.fromtimestamp(value, tz=timezone.utc).date()


def _to_decimal(value: str | int | float | Decimal | None) -> Decimal | None:
    if value is None or value == "":
        return None
    return Decimal(str(value))


def fetch_account_set(
    access_url: str,
    *,
    days: int | None = None,
    start_date: date | None = None,
    end_date: date | None = None,
    simplefin_account_id: str | None = None,
) -> dict:
    """Fetch /accounts JSON from SimpleFIN Bridge (uses curl — Cloudflare blocks urllib)."""
    access_url = validate_access_url(access_url)
    base = access_url.rstrip("/")
    params: dict[str, str] = {"version": "2"}
    if start_date is not None and end_date is not None:
        start_dt = datetime.combine(start_date, datetime.min.time(), tzinfo=timezone.utc)
        end_dt = datetime.combine(end_date, datetime.max.time(), tzinfo=timezone.utc)
        params["start-date"] = str(int(start_dt.timestamp()))
        params["end-date"] = str(int(end_dt.timestamp()))
    elif days is not None:
        end = datetime.now(timezone.utc)
        start = end - timedelta(days=days)
        params["start-date"] = str(int(start.timestamp()))
        params["end-date"] = str(int(end.timestamp()))
    if simplefin_account_id:
        params["account"] = simplefin_account_id
    api_url = f"{base}/accounts?{urlencode(params)}"

    result = subprocess.run(
        ["curl", "-sL", "-w", "\n__HTTP_CODE__:%{http_code}", api_url],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise SimpleFinError(f"curl failed: {result.stderr or result.stdout}")

    body, _, trailer = result.stdout.rpartition("\n__HTTP_CODE__:")
    code = trailer.strip() if trailer else "?"
    if code != "200":
        raise SimpleFinError(f"SimpleFIN HTTP {code}: {body[:500]}")

    try:
        return json.loads(body)
    except json.JSONDecodeError as exc:
        raise SimpleFinError(f"SimpleFIN response is not JSON: {body[:200]!r}") from exc


def parse_accounts(payload: dict) -> list[SimpleFinAccount]:
    accounts: list[SimpleFinAccount] = []
    for raw in payload.get("accounts") or []:
        txns: list[SimpleFinTransaction] = []
        for txn in raw.get("transactions") or []:
            posted = _unix_to_date(txn.get("posted"))
            amount = _to_decimal(txn.get("amount"))
            if posted is None or amount is None:
                continue
            external_id = txn.get("id") or ""
            description = (txn.get("description") or txn.get("payee") or "").strip()
            txns.append(
                SimpleFinTransaction(
                    external_id=str(external_id),
                    transaction_date=posted,
                    amount=amount,
                    bank_orig_description=description,
                    pending=bool(txn.get("pending")),
                )
            )
        accounts.append(
            SimpleFinAccount(
                external_id=str(raw.get("id") or ""),
                name=str(raw.get("name") or ""),
                balance=_to_decimal(raw.get("balance")),
                balance_date=_unix_to_date(raw.get("balance-date")),
                transactions=txns,
            )
        )
    return accounts


def api_errors(payload: dict) -> list[str]:
    errlist = payload.get("errlist") or payload.get("errors") or []
    return [str(err) for err in errlist]
