#!/bin/bash

# deploy-multi-service.sh
# Manages the multi-service Docker setup with nginx proxy

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Multi-Service Docker Management Script"
echo "Project: Shadow Pivot AI with nginx proxy"
echo ""

# Function to load Azure credentials
load_azure_credentials() {
    echo "🔐 Loading Azure credentials..."
    if [ -f "$SCRIPT_DIR/get-azure-sercrets.sh" ]; then
        source "$SCRIPT_DIR/get-azure-sercrets.sh"
        echo "✅ Azure credentials loaded"
    else
        echo "⚠️  Azure credentials script not found, continuing without Azure env vars"
    fi
}

# Function to check Docker and Docker Compose
check_dependencies() {
    echo "🔍 Checking dependencies..."

    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed or not in PATH"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose is not installed or not in PATH"
        exit 1
    fi

    echo "✅ Docker and Docker Compose are available"
}

# Function to stop existing containers
stop_services() {
    echo "🛑 Stopping existing services..."
    cd "$PROJECT_ROOT"
    docker-compose down --remove-orphans
    echo "✅ Services stopped"
}

# Function to pull latest images
pull_images() {
    echo "📥 Pulling latest images..."
    cd "$PROJECT_ROOT"
    docker-compose pull
    echo "✅ Images updated"
}

# Function to start services
start_services() {
    echo "🚀 Starting services..."
    cd "$PROJECT_ROOT"
    docker-compose up -d
    echo "✅ Services started"
}

# Function to show service status
show_status() {
    echo ""
    echo "📊 Service Status:"
    cd "$PROJECT_ROOT"
    docker-compose ps

    echo ""
    echo "🌐 Service URLs:"
    echo "  Main Application (via nginx): http://localhost"
    echo "  Direct Application Access:    http://localhost:180"
    echo "  Nginx Health Check:          http://localhost/nginx-health"
}

# Function to show logs
show_logs() {
    echo "📋 Recent logs:"
    cd "$PROJECT_ROOT"
    docker-compose logs --tail=20
}

# Function to follow logs
follow_logs() {
    echo "📋 Following logs (Ctrl+C to exit):"
    cd "$PROJECT_ROOT"
    docker-compose logs -f
}

# Function to restart specific service
restart_service() {
    local service=$1
    if [ -z "$service" ]; then
        echo "Usage: $0 restart <service_name>"
        echo "Available services: nginx, shadow-pivot-ai"
        exit 1
    fi

    echo "🔄 Restarting $service..."
    cd "$PROJECT_ROOT"
    docker-compose restart "$service"
    echo "✅ $service restarted"
}

# Function to perform health checks
health_check() {
    echo "🏥 Performing health checks..."

    # Check nginx
    if curl -f -s http://localhost/nginx-health > /dev/null; then
        echo "✅ Nginx proxy is healthy"
    else
        echo "❌ Nginx proxy health check failed"
    fi

    # Check main app via nginx
    if curl -f -s http://localhost > /dev/null; then
        echo "✅ Main application is accessible via nginx"
    else
        echo "❌ Main application is not accessible via nginx"
    fi

    # Check direct app access
    if curl -f -s http://localhost:180 > /dev/null; then
        echo "✅ Direct application access is working"
    else
        echo "❌ Direct application access failed"
    fi
}

# Main deployment function
deploy() {
    check_dependencies
    load_azure_credentials
    stop_services
    pull_images
    start_services

    echo ""
    echo "⏳ Waiting for services to be ready..."
    sleep 10

    show_status
    health_check

    echo ""
    echo "🎉 Deployment complete!"
    echo "   Access your application at: http://localhost"
}

# Parse command line arguments
case "${1:-deploy}" in
    "deploy"|"up")
        deploy
        ;;
    "stop"|"down")
        stop_services
        ;;
    "restart")
        if [ -n "$2" ]; then
            restart_service "$2"
        else
            echo "🔄 Restarting all services..."
            stop_services
            start_services
        fi
        show_status
        ;;
    "status"|"ps")
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "follow"|"tail")
        follow_logs
        ;;
    "health")
        health_check
        ;;
    "pull")
        pull_images
        ;;
    *)
        echo "Usage: $0 {deploy|up|stop|down|restart [service]|status|logs|follow|health|pull}"
        echo ""
        echo "Commands:"
        echo "  deploy/up     - Full deployment (stop, pull, start)"
        echo "  stop/down     - Stop all services"
        echo "  restart       - Restart all services"
        echo "  restart <svc> - Restart specific service (nginx, shadow-pivot-ai)"
        echo "  status        - Show service status"
        echo "  logs          - Show recent logs"
        echo "  follow        - Follow logs in real-time"
        echo "  health        - Perform health checks"
        echo "  pull          - Pull latest images"
        exit 1
        ;;
esac
