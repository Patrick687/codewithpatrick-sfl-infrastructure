#!/bin/bash

# Development Environment Startup Script
# This script sets up and starts the development environment

set -e

echo "🚀 Starting SFL Development Environment..."

# Check if .env.dev.local exists
if [ ! -f .env.dev.local ]; then
    echo "❌ .env.dev.local not found!"
    echo "📋 Please copy .env.dev.template to .env.dev.local and configure your values:"
    echo "   cp .env.dev.template .env.dev.local"
    echo "   Then edit .env.dev.local with your actual development values."
    exit 1
fi

echo "✅ Found .env.dev.local"
echo "🐳 Starting Docker Compose development environment..."

# Start with development configuration
docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev.local up --build -d

echo "🎉 Development environment started!"
echo ""
echo "📊 Services running:"
echo "   - PostgreSQL: http://localhost:5432"
echo "   - Auth Service: http://localhost:3001"
echo "   - League Service: http://localhost:3002"
echo "   - Gateway: http://localhost:3000"
echo ""
echo "🔍 To view logs: docker compose logs -f [service-name]"
echo "🛑 To stop: ./scripts/dev-down.sh"
echo "🧹 Full cleanup: ./scripts/dev-down.sh --full"
