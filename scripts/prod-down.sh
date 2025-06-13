#!/bin/bash

# Production Environment Shutdown Script
# This script stops the production environment

set -e

echo "🛑 Stopping SFL Production Environment..."

# Check if .env.prod.local exists
if [ ! -f .env.prod.local ]; then
    echo "❌ .env.prod.local not found!"
    echo "📋 Production environment may not be configured yet."
    echo "   Run './scripts/prod-up.sh' first to set up production."
    exit 1
fi

# Stop the containers
echo "🔄 Stopping Docker Compose production services..."
if docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod.local down; then
    echo "✅ Production services stopped successfully"
else
    echo "⚠️  Some services may not have been running"
fi

echo ""
echo "✅ Production environment shutdown complete!"
echo ""
echo "💡 Quick commands:"
echo "   🚀 Start again: ./scripts/prod-up.sh"
echo "   📊 Check status: docker compose ps"
