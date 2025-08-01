#!/bin/sh

# Run dbt with optional SELECT_ARG and upload manifest.json to the specified GCS bucket

# Fail on error
set -e

# Use SELECT_ARG if provided, otherwise empty
SELECT_ARG=${SELECT_ARG:-""}

# Ensure GCS_BUCKET is set
if [ -z "$GCS_BUCKET" ]; then
  echo "Error: GCS_BUCKET environment variable is not set."
  exit 1
fi

uv run dbt run --profiles-dir /app --project-dir /app --target prod ${SELECT_ARG:+--select $SELECT_ARG}

/root/google-cloud-sdk/bin/gcloud storage cp /app/target/manifest.json gs://$GCS_BUCKET/manifest/manifest.json
