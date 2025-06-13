#!/bin/bash

# Production Environment Startup Script
# This script sets up and starts the production environment

set -e

echo "🚀 Starting SFL Production Environment..."

# Check if .env.prod.local exists
if [ ! -f .env.prod.local ]; then
    echo "❌ .env.prod.local not found!"
    echo "📋 Please copy .env.prod.template to .env.prod.local and configure your SECURE values:"
    echo "   cp .env.prod.template .env.prod.local"
    echo "   Then edit .env.prod.local with your actual production values."
    echo ""
    echo "⚠️  IMPORTANT: Use strong, secure passwords and secrets in production!"
    exit 1
fi

echo "✅ Found .env.prod.local"
echo "🐳 Starting Docker Compose production environment..."

# Start with production configuration
docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod.local up --build -d

echo "🎉 Production environment started!"
echo ""
echo "📊 Services running:"
echo "   - PostgreSQL: http://localhost:5432"
echo "   - Auth Service: http://localhost:3001"
echo "   - League Service: http://localhost:3002"
echo "   - Gateway: http://localhost:3000"
echo ""
echo "🔍 To view logs: docker compose logs -f [service-name]"
echo "🛑 To stop: docker compose down"
