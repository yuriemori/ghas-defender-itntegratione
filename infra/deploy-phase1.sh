#!/usr/bin/env bash
# -------------------------------------------------------
# Phase 1: Deploy Resource Group + ACR (Infrastructure only)
# Container image build & push is handled by GitHub Actions.
# -------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_NAME="phase1-$(date +%Y%m%d-%H%M%S)"

echo "=== Phase 1: Infrastructure Deployment ==="

# Deploy Bicep (subscription scope)
echo "[1/1] Deploying Bicep template..."
DEPLOY_OUTPUT=$(az deployment sub create \
  --location eastus \
  --name "$DEPLOYMENT_NAME" \
  --template-file "$SCRIPT_DIR/main.bicep" \
  --parameters "$SCRIPT_DIR/main.parameters.json" \
  --query 'properties.outputs' \
  -o json)

RG_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.resourceGroupName.value')
ACR_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.acrName.value')
ACR_LOGIN_SERVER=$(echo "$DEPLOY_OUTPUT" | jq -r '.acrLoginServer.value')

echo ""
echo "=== Phase 1 Complete ==="
echo "  Resource Group : $RG_NAME"
echo "  ACR Name       : $ACR_NAME"
echo "  ACR Login      : $ACR_LOGIN_SERVER"
echo ""
echo "Next: Run the 'Deploy & Push Container' GitHub Actions workflow."
