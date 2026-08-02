#!/usr/bin/env bash
# Creates/updates the daily stop-rds Lambda + EventBridge schedule in us-east-2.
# Requires: aws CLI, zip, jq. Uses the caller's default credentials/profile.
set -euo pipefail

REGION="${AWS_REGION:-us-east-2}"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
FUNCTION_NAME="${FUNCTION_NAME:-stop-rds-daily}"
ROLE_NAME="${ROLE_NAME:-stop-rds-daily-role}"
RULE_NAME="${RULE_NAME:-stop-rds-daily}"
INSTANCE_ID="${DB_INSTANCE_IDENTIFIER:-database-1}"
# 06:00 UTC daily — adjust as needed
SCHEDULE="${SCHEDULE:-cron(0 6 * * ? *)}"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Account=$ACCOUNT_ID Region=$REGION Instance=$INSTANCE_ID"

ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
if ! aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
  echo "Creating role $ROLE_NAME"
  aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "lambda.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }' >/dev/null
  aws iam put-role-policy \
    --role-name "$ROLE_NAME" \
    --policy-name stop-rds \
    --policy-document "file://${DIR}/iam_policy.json"
  echo "Waiting for role propagation..."
  sleep 10
else
  aws iam put-role-policy \
    --role-name "$ROLE_NAME" \
    --policy-name stop-rds \
    --policy-document "file://${DIR}/iam_policy.json"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
(cd "$DIR" && zip -q "${TMP}/function.zip" lambda_function.py)

if aws lambda get-function --region "$REGION" --function-name "$FUNCTION_NAME" >/dev/null 2>&1; then
  echo "Updating function code $FUNCTION_NAME"
  aws lambda update-function-code \
    --region "$REGION" \
    --function-name "$FUNCTION_NAME" \
    --zip-file "fileb://${TMP}/function.zip" >/dev/null
  aws lambda wait function-updated --region "$REGION" --function-name "$FUNCTION_NAME"
  aws lambda update-function-configuration \
    --region "$REGION" \
    --function-name "$FUNCTION_NAME" \
    --environment "Variables={DB_INSTANCE_IDENTIFIER=${INSTANCE_ID}}" \
    --timeout 60 \
    --memory-size 128 >/dev/null
else
  echo "Creating function $FUNCTION_NAME"
  aws lambda create-function \
    --region "$REGION" \
    --function-name "$FUNCTION_NAME" \
    --runtime python3.12 \
    --handler lambda_function.handler \
    --role "$ROLE_ARN" \
    --zip-file "fileb://${TMP}/function.zip" \
    --timeout 60 \
    --memory-size 128 \
    --environment "Variables={DB_INSTANCE_IDENTIFIER=${INSTANCE_ID}}" >/dev/null
fi

aws events put-rule \
  --region "$REGION" \
  --name "$RULE_NAME" \
  --schedule-expression "$SCHEDULE" \
  --state ENABLED \
  --description "Stop RDS ${INSTANCE_ID} daily if running" >/dev/null

FUNCTION_ARN="$(aws lambda get-function --region "$REGION" --function-name "$FUNCTION_NAME" --query Configuration.FunctionArn --output text)"
RULE_ARN="$(aws events describe-rule --region "$REGION" --name "$RULE_NAME" --query Arn --output text)"

aws lambda add-permission \
  --region "$REGION" \
  --function-name "$FUNCTION_NAME" \
  --statement-id "${RULE_NAME}-invoke" \
  --action lambda:InvokeFunction \
  --principal events.amazonaws.com \
  --source-arn "$RULE_ARN" >/dev/null 2>&1 || true

aws events put-targets \
  --region "$REGION" \
  --rule "$RULE_NAME" \
  --targets "Id=1,Arn=${FUNCTION_ARN}" >/dev/null

echo "Done."
echo "  Function: $FUNCTION_ARN"
echo "  Schedule: $SCHEDULE ($RULE_NAME)"
echo "  Invoke now: aws lambda invoke --region $REGION --function-name $FUNCTION_NAME /dev/stdout"
