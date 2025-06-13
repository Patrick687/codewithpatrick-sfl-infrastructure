#!/bin/bash

# Database Only Startup Script
# This script starts only PostgreSQL for local development outside Docker

set -e

echo "🐘 Starting SFL Database Only..."

# Check if .env.dev.local exists
if [ ! -f .env.dev.local ]; then
    echo "❌ .env.dev.local not found!"
    echo "📋 Please copy .env.dev.template to .env.dev.local and configure your values:"
    echo "   cp .env.dev.template .env.dev.local"
    exit 1
fi

echo "✅ Found .env.dev.local"
echo "🐳 Starting PostgreSQL container..."

# Start only the database service
docker compose -f docker-compose.yml --env-file .env.dev.local up postgres -d

echo "🎉 Database started!"
echo ""
echo "📊 PostgreSQL running on: localhost:5432"
echo "🔗 Connection string: postgresql://postgres:postgres@localhost:5432/postgres"
echo ""
echo "💡 Now you can run your services locally with:"
echo "   cd auth && npm run dev"
echo "   cd sfl_gateway && npm run dev"
echo ""
echo "🛑 To stop database: docker compose down"
