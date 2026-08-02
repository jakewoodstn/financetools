"""Daily RDS stopper — works around the 7-day auto-restart of stopped instances.

Env:
  DB_INSTANCE_IDENTIFIER  RDS instance id (default: database-1)
"""

from __future__ import annotations

import json
import logging
import os

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Statuses where stop_db_instance is valid.
STOPPABLE = {"available"}
# Already down or in flight — no action needed.
NOOP = {"stopped", "stopping", "storage-optimization"}


def handler(event, context):
    instance_id = os.environ.get("DB_INSTANCE_IDENTIFIER", "database-1")
    rds = boto3.client("rds")

    try:
        resp = rds.describe_db_instances(DBInstanceIdentifier=instance_id)
    except ClientError:
        logger.exception("describe_db_instances failed for %s", instance_id)
        raise

    instances = resp.get("DBInstances") or []
    if not instances:
        raise RuntimeError(f"No DB instance found: {instance_id}")

    status = (instances[0].get("DBInstanceStatus") or "").lower()
    result = {
        "instance_id": instance_id,
        "status": status,
        "action": "none",
    }

    if status in NOOP:
        logger.info("%s is %s — nothing to do", instance_id, status)
        return result

    if status not in STOPPABLE:
        logger.warning("%s is %s — not stoppable this run", instance_id, status)
        result["action"] = "skipped"
        return result

    logger.info("Stopping %s (status=%s)", instance_id, status)
    rds.stop_db_instance(DBInstanceIdentifier=instance_id)
    result["action"] = "stop_requested"
    logger.info("stop_db_instance requested for %s", instance_id)
    return result


# Local smoke test: python lambda_function.py
if __name__ == "__main__":
    print(json.dumps(handler({}, None), indent=2))
