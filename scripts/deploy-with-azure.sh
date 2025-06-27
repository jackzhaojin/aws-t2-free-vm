#!/bin/bash

# deploy.sh
# Deploys Shadow Pivot AI using Docker Compose

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Starting Shadow Pivot AI deployment..."
echo "📁 Project directory: $PROJECT_DIR"

# Change to project directory
cd "$PROJECT_DIR"

# Load Azure credentials from Parameter Store
source "$SCRIPT_DIR/get-azure-sercrets.sh"

# Pull latest image
echo "📥 Pulling latest image..."
docker compose pull

# Stop and remove existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# Start services
echo "🆙 Starting services..."
docker compose up -d

# Wait for service to be ready
echo "⏳ Waiting for service to be ready..."
timeout 60 bash -c 'until curl -f http://localhost/health 2>/dev/null; do sleep 2; done' || {
    echo "❌ Service failed to start properly"
    echo "📋 Container logs:"
    docker compose logs
    exit 1
}

# Get public IP for display
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "localhost")

echo ""
echo "✅ Deployment complete!"
echo "🌐 Service available at: http://$PUBLIC_IP"
echo "📊 Check status with: docker compose ps"
echo "📋 View logs with: docker compose logs -f"
