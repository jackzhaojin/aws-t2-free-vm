#!/bin/bash

# get-azure-secrets.sh
# Loads Azure credentials from AWS Parameter Store

set -e

echo "🔐 Loading Azure credentials from Parameter Store..."

export AZURE_CLIENT_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/client-id" --query "Parameter.Value" --output text)
export AZURE_CLIENT_SECRET=$(aws ssm get-parameter --name "/shadow-pivot/azure/client-secret" --with-decryption --query "Parameter.Value" --output text)
export AZURE_TENANT_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/tenant-id" --query "Parameter.Value" --output text)
export AZURE_SUBSCRIPTION_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/subscription-id" --query "Parameter.Value" --output text)

echo "✅ Azure credentials loaded from Parameter Store"

# Validate that all variables are set
if [[ -z "$AZURE_CLIENT_ID" || -z "$AZURE_CLIENT_SECRET" || -z "$AZURE_TENANT_ID" || -z "$AZURE_SUBSCRIPTION_ID" ]]; then
    echo "❌ Error: One or more Azure credentials are missing from Parameter Store"
    exit 1
fi