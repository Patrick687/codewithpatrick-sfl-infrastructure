#!/bin/bash

# Development Environment Shutdown Script
# This script stops and optionally removes the development environment

set -e

echo "🛑 Stopping SFL Development Environment..."

# Function to display usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --volumes  Remove volumes (WARNING: This will delete database data)"
    echo "  -c, --clean    Remove containers and networks (but keep volumes)"
    echo "  -f, --full     Full cleanup: stop, remove containers, networks, and volumes"
    echo ""
    echo "Default: Just stops the containers (keeps everything for quick restart)"
}

# Parse command line arguments
REMOVE_VOLUMES=false
REMOVE_CONTAINERS=false
FULL_CLEANUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -v|--volumes)
            REMOVE_VOLUMES=true
            shift
            ;;
        -c|--clean)
            REMOVE_CONTAINERS=true
            shift
            ;;
        -f|--full)
            FULL_CLEANUP=true
            REMOVE_VOLUMES=true
            REMOVE_CONTAINERS=true
            shift
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Stop the containers
echo "🔄 Stopping Docker Compose services..."
if docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev.local down; then
    echo "✅ Services stopped successfully"
else
    echo "⚠️  Some services may not have been running"
fi

# Additional cleanup based on flags
if [ "$REMOVE_CONTAINERS" = true ] || [ "$FULL_CLEANUP" = true ]; then
    echo "🧹 Removing containers and networks..."
    docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev.local down --remove-orphans
fi

if [ "$REMOVE_VOLUMES" = true ] || [ "$FULL_CLEANUP" = true ]; then
    echo "⚠️  Removing volumes (this will delete database data)..."
    read -p "Are you sure? This will delete all database data! (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev.local down --volumes
        echo "🗑️  Volumes removed"
    else
        echo "📦 Keeping volumes (database data preserved)"
    fi
fi

echo ""
echo "✅ Development environment shutdown complete!"
echo ""
echo "💡 Quick commands:"
echo "   🚀 Start again: ./scripts/dev-up.sh"
echo "   📊 Check status: docker compose ps"
echo "   🧹 Full cleanup: ./scripts/dev-down.sh --full"
