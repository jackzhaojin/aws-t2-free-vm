#!/bin/bash

# Load Azure credentials from Parameter Store
source ~/get-azure-secrets.sh

# Update container
sudo docker stop shadow-pivot-ai 2>/dev/null || true
sudo docker rm shadow-pivot-ai 2>/dev/null || true
docker pull ghcr.io/jackzhaojin/shadow-pivot-ai-agentv2:release-latest

sudo docker run -d \
  --name shadow-pivot-ai \
  -p 80:3000 \
  --restart unless-stopped \
  -e AZURE_CLIENT_ID="$AZURE_CLIENT_ID" \
  -e AZURE_CLIENT_SECRET="$AZURE_CLIENT_SECRET" \
  -e AZURE_TENANT_ID="$AZURE_TENANT_ID" \
  -e AZURE_SUBSCRIPTION_ID="$AZURE_SUBSCRIPTION_ID" \
  ghcr.io/jackzhaojin/shadow-pivot-ai-agentv2:release-latest

echo "Deployment complete with Azure authentication!"
docker ps | grep shadow-pivot-ai