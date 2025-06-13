#!/bin/bash

# SFL Development with Separate Repositories Script

set -e

echo "🔗 Setting up SFL development with separate repositories..."

# Function to clone or link repository
setup_repo() {
    local repo_name=$1
    local repo_url=$2
    local local_path=$3

    if [ ! -d "$local_path" ]; then
        echo "📁 Setting up $repo_name..."
        echo "Choose an option:"
        echo "1) Clone from GitHub"
        echo "2) Link existing local repository"
        echo "3) Skip (repository already set up)"
        
        read -p "Enter choice (1-3): " choice
        
        case $choice in
            1)
                read -p "Enter GitHub repository URL: " repo_url
                git clone "$repo_url" "$local_path"
                ;;
            2)
                read -p "Enter path to existing $repo_name repository: " existing_path
                if [ -d "$existing_path" ]; then
                    ln -s "$(realpath "$existing_path")" "$local_path"
                    echo "✅ Linked $local_path to $existing_path"
                else
                    echo "❌ Directory $existing_path does not exist"
                    exit 1
                fi
                ;;
            3)
                echo "⏭️ Skipping $repo_name setup"
                ;;
            *)
                echo "❌ Invalid choice"
                exit 1
                ;;
        esac
    else
        echo "✅ $repo_name already exists at $local_path"
    fi
}

# Setup repositories
setup_repo "Auth Service" "https://github.com/your-username/sfl-auth.git" "auth"
setup_repo "Gateway Service" "https://github.com/your-username/sfl-gateway.git" "sfl_gateway"

# Run the main setup
echo "🚀 Running main setup..."
./scripts/setup-dev.sh

echo "✅ Multi-repository setup complete!"
echo ""
echo "📝 Development workflow:"
echo "   1. Make changes in individual service repositories"
echo "   2. Changes will be hot-reloaded in Docker containers"
echo "   3. Commit and push changes to individual repositories"
echo "   4. Update Docker images for deployment"
