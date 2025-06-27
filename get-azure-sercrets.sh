#!/bin/bash

export AZURE_CLIENT_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/client-id" --query "Parameter.Value" --output text)
export AZURE_CLIENT_SECRET=$(aws ssm get-parameter --name "/shadow-pivot/azure/client-secret" --with-decryption --query "Parameter.Value" --output text)
export AZURE_TENANT_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/tenant-id" --query "Parameter.Value" --output text)
export AZURE_SUBSCRIPTION_ID=$(aws ssm get-parameter --name "/shadow-pivot/azure/subscription-id" --query "Parameter.Value" --output text)

echo "✅ Azure credentials loaded from Parameter Store"