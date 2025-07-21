# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains AWS EC2 deployment scripts and Docker configurations for the Shadow Pivot AI application. It's a containerized deployment setup using Docker Compose with nginx as a reverse proxy.

## Key Commands

### Deployment Commands
```bash
# Full deployment (recommended)
./scripts/deploy-multi-service.sh deploy

# Alternative: Legacy deployment with Azure credentials
./scripts/deploy-with-azure.sh

# Direct Docker Compose usage
docker-compose up -d
```

### Management Commands
```bash
# Stop all services
./scripts/deploy-multi-service.sh stop

# View service status
./scripts/deploy-multi-service.sh status

# View logs
./scripts/deploy-multi-service.sh logs

# Follow logs in real-time
./scripts/deploy-multi-service.sh follow

# Health checks
./scripts/deploy-multi-service.sh health

# Restart specific service
./scripts/deploy-multi-service.sh restart nginx
./scripts/deploy-multi-service.sh restart shadow-pivot-ai

# Pull latest images
./scripts/deploy-multi-service.sh pull
```

### Environment Setup
```bash
# Install Docker and dependencies on EC2
./scripts/install-essentials.sh

# Load Azure credentials from AWS Parameter Store
source ./scripts/get-azure-sercrets.sh
```

## Architecture

The deployment consists of two Docker services:

1. **nginx-proxy**: Reverse proxy on port 80 that routes traffic to the main application
2. **shadow-pivot-ai**: Main application container running on internal port 3000

```
Internet → Port 80 (nginx) → nginx reverse proxy → shadow-pivot-ai:3000
                           ↗ Port 180 (direct access)
```

### Access Points
- **Main Application**: http://localhost (port 80 via nginx)
- **Direct Access**: http://localhost:180 (bypass nginx)
- **Nginx Health**: http://localhost/nginx-health

## Key Configuration Files

- `docker-compose.yml`: Main service definitions with health checks and logging
- `docker/nginx/nginx.conf`: Nginx reverse proxy configuration with WebSocket support
- `scripts/deploy-multi-service.sh`: Primary management script with comprehensive commands
- `scripts/get-azure-sercrets.sh`: Loads Azure credentials from AWS Parameter Store

## Azure Integration

The application requires Azure credentials loaded as environment variables:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET` 
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

These are automatically loaded from AWS Parameter Store using paths like `/shadow-pivot/azure/client-id`.

## Adding New Services

To extend the multi-service setup:

1. Add new service definition to `docker-compose.yml`
2. Update `docker/nginx/nginx.conf` with new location blocks
3. Restart nginx: `./scripts/deploy-multi-service.sh restart nginx`

## Troubleshooting

- Check service logs: `./scripts/deploy-multi-service.sh logs`
- Verify health: `./scripts/deploy-multi-service.sh health`
- For port conflicts: Stop other services using port 80
- Container issues: Use `docker-compose down --remove-orphans` to clean up