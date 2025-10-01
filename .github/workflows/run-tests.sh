#!/bin/bash
set -e

TEST_URL="http://localhost:60151/testbox?format=json&only=failure,error"
RESULT_FILE="test_results.json"
MAX_RETRIES=3
RETRY_COUNT=0
HTTP_CODE="000"

while [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ] && [ "$HTTP_CODE" != "200" ]; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "Test attempt ${RETRY_COUNT} of ${MAX_RETRIES}..."
  HTTP_CODE=$(curl -s -o "$RESULT_FILE" -w "%{http_code}" "$TEST_URL" || echo "000")
  echo "Attempt ${RETRY_COUNT}: Received HTTP code ${HTTP_CODE}"
  if [ "$HTTP_CODE" != "200" ] && [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; then
    echo "Waiting 10 seconds before retry..."
    sleep 10
  fi
done

if [ -f "$RESULT_FILE" ]; then
  echo "Response content:"
  cat "$RESULT_FILE"
fi

if [ "$HTTP_CODE" = "200" ]; then
  echo "✅ Tests passed with HTTP 200"
  exit 0
else
  echo "❌ Tests failed after $RETRY_COUNT attempts with code: $HTTP_CODE"
  exit 1
fi
