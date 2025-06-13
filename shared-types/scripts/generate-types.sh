#!/bin/bash

# Generate TypeScript types from OpenAPI specs
# This script can be run when services are running locally

set -e

echo "🚀 Generating TypeScript types from OpenAPI specs..."

# Check if services are running
echo "Checking if services are accessible..."

# Function to check if service is running
check_service() {
    local url=$1
    local service_name=$2
    
    if curl -f -s "$url" > /dev/null; then
        echo "✅ $service_name is accessible"
        return 0
    else
        echo "❌ $service_name is not accessible at $url"
        return 1
    fi
}

# Check all services
gateway_running=false
auth_running=false
league_running=false

if check_service "http://localhost:3000/health" "Gateway"; then
    gateway_running=true
fi

if check_service "http://localhost:3001/health" "Auth Service"; then
    auth_running=true
fi

if check_service "http://localhost:3002/health" "League Service"; then
    league_running=true
fi

# Generate types from running services
if [ "$gateway_running" = true ]; then
    echo "📝 Generating Gateway types..."
    npx openapi-typescript http://localhost:3000/api-docs.json -o src/generated/gateway.ts
    echo "✅ Gateway types generated"
else
    echo "⚠️  Skipping Gateway - service not running"
fi

if [ "$auth_running" = true ]; then
    echo "📝 Generating Auth types..."
    npx openapi-typescript http://localhost:3001/api-docs.json -o src/generated/auth.ts
    echo "✅ Auth types generated"
else
    echo "⚠️  Skipping Auth - service not running"
fi

if [ "$league_running" = true ]; then
    echo "📝 Generating League types..."
    npx openapi-typescript http://localhost:3002/api-docs.json -o src/generated/league.ts
    echo "✅ League types generated"
else
    echo "⚠️  Skipping League - service not running"
fi

echo ""
echo "🎉 Type generation complete!"
echo ""
echo "Next steps:"
echo "1. Review generated types in src/generated/"
echo "2. Run 'npm run build' to compile the package"
echo "3. Install this package in your services: npm install ../shared-types"
