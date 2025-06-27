# Shadow Pivot AI Deployment

This repository contains deployment scripts and configuration for the Shadow Pivot AI application on AWS EC2.

## Quick Start

1. Clone this repository to your EC2 instance
2. Run the installation script: `./scripts/install-docker.sh`
3. Deploy the application: `./scripts/deploy.sh`

## Files

- `docker-compose.yml` - Main application configuration
- `scripts/get-azure-secrets.sh` - Loads Azure credentials from AWS Parameter Store
- `scripts/deploy.sh` - Deployment script using Docker Compose
- `scripts/install-docker.sh` - Docker installation script

## Prerequisites

- AWS EC2 instance with appropriate IAM role for Parameter Store access
- Azure credentials stored in AWS Parameter Store under `/shadow-pivot/azure/*`
