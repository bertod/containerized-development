#!/bin/bash
set -e

# Authenticate with Google Cloud.
# First checks for an active session; if none, falls back to a service account key file.
if gcloud auth list --filter="status:ACTIVE" --format="value(account)" 2>/dev/null ; then
    echo "Google Cloud: active session found ($(gcloud config get-value account))."
else
    echo "Google Cloud: no active session, authenticating with key file..."

    if [[ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
        echo "ERROR: GOOGLE_APPLICATION_CREDENTIALS is not set." >&2
        exit 1
    fi

    if [[ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
        echo "ERROR: Key file not found at '$GOOGLE_APPLICATION_CREDENTIALS'." >&2
        exit 1
    fi

    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    echo "Google Cloud: authenticated as $(gcloud config get-value account)."
fi

exec /bin/bash
