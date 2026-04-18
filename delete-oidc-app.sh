#!/bin/bash
set -euo pipefail

# Usage:
# ./delete-oidc-app.sh {APP_NAME} {ORG/REPO} [--dry-run]

APP_NAME=$1
REPO=$2
DRY_RUN=${3:-""}

IS_DRY_RUN=false
if [[ "$DRY_RUN" == "--dry-run" ]]; then
    IS_DRY_RUN=true
    echo "🔍 DRY RUN MODE ENABLED — No changes will be made."
fi

run_or_echo() {
    if $IS_DRY_RUN; then
        echo "[DRY RUN] $*"
    else
        eval "$@"
    fi
}

echo "Checking Azure CLI login status..."
EXPIRED_TOKEN=$(az ad signed-in-user show --query 'id' -o tsv || true)

if [[ -z "$EXPIRED_TOKEN" ]]; then
    run_or_echo "az login -o none"
fi

echo "Fetching subscription ID..."
SUB_ID=$(az account show --query id -o tsv)
echo "SUB_ID: $SUB_ID"

echo "Looking up Azure AD application..."
APP_ID=$(az ad app list --filter "displayName eq '$APP_NAME'" --query "[0].appId" -o tsv)

if [[ -z "$APP_ID" ]]; then
    echo "❌ No application found with name '$APP_NAME'. Nothing to delete."
    exit 0
fi

echo "APP_ID: $APP_ID"

echo "Looking up Service Principal..."
SP_ID=$(az ad sp list --filter "appId eq '$APP_ID'" --query "[0].id" -o tsv || true)

if [[ -n "$SP_ID" ]]; then
    echo "Deleting Service Principal (role assignments will be auto-removed)..."
    run_or_echo "az ad sp delete --id $SP_ID"
else
    echo "No Service Principal found."
fi

echo "Fetching Federated Identity Credentials..."
FICS=$(az ad app federated-credential list --id "$APP_ID" --query "[].id" -o tsv || true)

if [[ -n "$FICS" ]]; then
    while IFS= read -r FIC_ID; do
        echo "Deleting FIC: $FIC_ID"
        run_or_echo "az ad app federated-credential delete --id $APP_ID --federated-credential-id $FIC_ID"
    done <<< "$FICS"
else
    echo "No FICs found."
fi

echo "Deleting Azure AD Application..."
run_or_echo "az ad app delete --id $APP_ID"

echo "Azure AD Application deletion complete (or simulated)."

echo "Deleting GitHub secrets..."
run_or_echo "gh auth login"

run_or_echo "gh secret delete AZURE_CLIENT_ID --repo $REPO || true"
run_or_echo "gh secret delete AZURE_SUBSCRIPTION_ID --repo $REPO || true"
run_or_echo "gh secret delete AZURE_TENANT_ID --repo $REPO || true"

echo "🎉 Cleanup complete."
if $IS_DRY_RUN; then
    echo "No changes were made because dry-run mode was enabled."
fi
