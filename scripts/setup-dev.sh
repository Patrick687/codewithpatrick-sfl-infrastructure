#!/bin/bash

# SFL Local Development Setup Script

set -e

echo "🚀 Setting up SFL local development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your actual values before proceeding."
    echo "   Especially set proper values for JWT_SECRET and Google OAuth credentials."
    read -p "Press Enter to continue after editing .env file..."
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p logs
mkdir -p data/postgres

# Check if service repositories exist
if [ ! -d "auth" ]; then
    echo "❌ Auth service directory not found. Please ensure you have:"
    echo "   - Cloned the auth repository to ./auth"
    echo "   - Or create a symlink: ln -s /path/to/sfl-auth ./auth"
    exit 1
fi

if [ ! -d "sfl_gateway" ]; then
    echo "❌ Gateway service directory not found. Please ensure you have:"
    echo "   - Cloned the gateway repository to ./sfl_gateway"
    echo "   - Or create a symlink: ln -s /path/to/sfl-gateway ./sfl_gateway"
    exit 1
fi

# Build development images
echo "🔨 Building development Docker images..."
docker-compose -f docker-compose.dev.yml build

# Start services
echo "🐳 Starting services..."
docker-compose -f docker-compose.dev.yml up -d postgres

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

# Start the application services
echo "🚀 Starting application services..."
docker-compose -f docker-compose.dev.yml up -d

echo "✅ Setup complete!"
echo ""
echo "🌐 Services are available at:"
echo "   - Gateway: http://localhost:3000"
echo "   - Gateway API Docs: http://localhost:3000/api-docs"
echo "   - Auth Service: http://localhost:3001"
echo "   - Auth API Docs: http://localhost:3001/api-docs"
echo "   - PostgreSQL: localhost:5432"
echo ""
echo "📊 To view logs: docker-compose -f docker-compose.dev.yml logs -f"
echo "🛑 To stop: docker-compose -f docker-compose.dev.yml down"
