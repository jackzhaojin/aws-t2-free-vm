# Multi-Service Docker Setup Guide

## Architecture Overview

```
Internet/EC2 Traffic
         ↓
    Port 80 (nginx)
         ↓
nginx reverse proxy
         ↓
shadow-pivot-ai:3000 (internal)
         ↑
    Port 180 (direct access)
```

## Services

- **nginx-proxy**: Reverse proxy on port 80, routes all traffic to main app
- **shadow-pivot-ai**: Your main application accessible on port 180 (direct) or port 80 (via nginx)

## Quick Start

```bash
# Deploy everything
./scripts/deploy-multi-service.sh

# Or just use docker-compose directly
docker-compose up -d
```

## Management Commands

```bash
# Full deployment (recommended)
./scripts/deploy-multi-service.sh deploy

# Stop all services
./scripts/deploy-multi-service.sh stop

# View status
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
```

## Access Points

- **Main Application**: http://localhost (port 80 via nginx)
- **Direct Access**: http://localhost:180 (bypass nginx)
- **Nginx Health**: http://localhost/nginx-health

## Adding New Services

To add more services to this setup:

1. Add the new service to `docker-compose.yml`
2. Update `docker/nginx/nginx.conf` with new location blocks:
   ```nginx
   location /api {
       proxy_pass http://api-service:3001;
       # ... proxy headers
   }
   ```
3. Restart with `./scripts/deploy-multi-service.sh restart nginx`

## Troubleshooting

- **Port 80 in use**: Stop other services using port 80
- **Service won't start**: Check logs with `./scripts/deploy-multi-service.sh logs`
- **Can't reach app**: Verify health checks with `./scripts/deploy-multi-service.sh health`

## Files Structure

```
project/
├── docker-compose.yml          # Main service definitions
├── docker/
│   └── nginx/
│       └── nginx.conf         # Nginx reverse proxy config
└── scripts/
    ├── deploy-multi-service.sh # Management script
    ├── get-azure-sercrets.sh  # Azure credentials loader
    └── deploy-with-azure.sh   # Azure deployment
```
