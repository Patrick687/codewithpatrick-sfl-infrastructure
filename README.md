# SFL Infrastructure

This repository contains Docker Compose files and deployment configurations for
the SFL (Social Football League) application.

## Architecture

The SFL application consists of multiple microservices:

- **Auth Service**: User authentication and authorization
- **Gateway Service**: API Gateway that routes requests to microservices
- **PostgreSQL**: Primary database for user data

## Repository Structure

```
sfl-infrastructure/
├── README.md                # This file
├── docker-compose.yml       # Production deployment
├── docker-compose.dev.yml   # Development with hot reloading
├── docker-compose.prod.yml  # Production configuration
├── .env.example            # Environment template
├── init-db.sql            # Database initialization
├── scripts/                # Setup and deployment scripts
│   ├── setup-dev.sh        # Development environment setup
│   └── setup-separate-repos.sh # Multi-repository setup
├── github-workflows/       # CI/CD workflow templates
│   ├── auth-service-workflow.yml
│   └── gateway-service-workflow.yml
├── DEPLOYMENT.md          # Detailed deployment guide
└── .vscode/               # VS Code configuration for debugging
```

## Quick Start

### For Development (Current Setup)

1. **Setup environment:**

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

2. **Start development environment:**
   ```bash
   ./scripts/setup-dev.sh
   ```

### For Production

1. **Configure environment:**

   ```bash
   cp .env.example .env
   # Edit .env with production values
   ```

2. **Deploy:**
   ```bash
   docker-compose up -d
   ```

## Services

- **Gateway**: http://localhost:3000
  - API Documentation: http://localhost:3000/api-docs
- **Auth Service**: http://localhost:3001
  - API Documentation: http://localhost:3001/api-docs
- **PostgreSQL**: localhost:5432

## Development Workflow

### Current Setup (Development Monorepo)

This repository currently contains the service code in `sfl_authService/` and
`sfl_gateway/` directories for development convenience.

### Future Setup (Separate Repositories)

When ready to split into separate repositories:

1. Create separate repositories:

   - `sfl-auth` for auth service
   - `sfl-gateway` for gateway service

2. Update `.gitignore` to ignore service directories
3. Use the setup scripts to link or clone the separate repositories

## Documentation

- [Deployment Guide](DEPLOYMENT.md) - Comprehensive deployment and setup guide
- [Environment Guide](ENV_GUIDE.md) - Environment variable configuration

2. Use the development compose file that mounts source code:
   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```
