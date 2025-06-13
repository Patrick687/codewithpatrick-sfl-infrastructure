# SFL Deployment Guide

## Repository Structure Options

### Option 1: Infrastructure Repository (Recommended)

Create a separate repository for infrastructure and deployment:

```
sfl-infrastructure/          # Main deployment repo
├── docker-compose.yml       # Production compose
├── docker-compose.dev.yml   # Development compose
├── .env.example            # Environment template
├── scripts/                # Setup and deployment scripts
├── nginx/                  # Reverse proxy config
└── docs/                   # Documentation

sfl-auth/                   # Separate auth service repo
sfl-gateway/                # Separate gateway service repo
```

### Option 2: Git Submodules

Use git submodules in your infrastructure repository:

```bash
git submodule add https://github.com/your-username/sfl-auth.git auth
git submodule add https://github.com/your-username/sfl-gateway.git sfl_gateway
```

### Option 3: Development Monorepo

Keep current structure for development, but deploy from separate repos:

```
sfl/                        # Development monorepo
├── auth/                   # Symlink or clone
├── sfl_gateway/           # Symlink or clone
├── docker-compose.dev.yml  # Development
└── scripts/               # Development scripts
```

## Setup Instructions

### For Separate Repositories

1. **Create the infrastructure repository:**

   ```bash
   mkdir sfl-infrastructure
   cd sfl-infrastructure
   git init
   ```

2. **Copy infrastructure files:**

   - `docker-compose.yml` (production)
   - `docker-compose.dev.yml` (development)
   - `.env.example`
   - `scripts/`
   - `init-db.sql`

3. **Setup for development:**

   ```bash
   # Clone or link service repositories
   git clone https://github.com/your-username/sfl-auth.git auth
   git clone https://github.com/your-username/sfl-gateway.git sfl_gateway

   # Or link existing repositories
   ln -s /path/to/sfl-auth auth
   ln -s /path/to/sfl-gateway sfl_gateway

   # Run setup
   ./scripts/setup-dev.sh
   ```

### For Production Deployment

1. **Setup environment:**

   ```bash
   cp .env.example .env
   # Edit .env with production values
   ```

2. **Deploy:**
   ```bash
   docker-compose up -d
   ```

## Docker Image Management

### Building Images

Each service repository should have its own Dockerfile and GitHub Actions:

**Auth Service:**

```dockerfile
# Multi-stage build
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM base AS development
RUN npm install
COPY . .
EXPOSE 3001 9229
CMD ["npm", "run", "dev"]

FROM base AS production
COPY . .
RUN npm run build
EXPOSE 3001
CMD ["npm", "start"]
```

### GitHub Actions

Each service should build and push images to GitHub Container Registry:

- Images tagged with branch name and latest
- Production builds triggered on main branch
- Development builds triggered on feature branches

### Image Versioning

```bash
# Production images
ghcr.io/your-username/sfl-auth:latest
ghcr.io/your-username/sfl-auth:v1.0.0
ghcr.io/your-username/sfl-auth:main-abc123

# Development images
ghcr.io/your-username/sfl-auth:develop-def456
```

## Development Workflow

1. **Local development with hot reloading:**

   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```

2. **Make changes in service repositories**

3. **Test locally with Docker:**

   ```bash
   docker-compose -f docker-compose.dev.yml restart auth-service
   ```

4. **Push changes to service repositories**

5. **GitHub Actions automatically builds new images**

6. **Update infrastructure repository with new image tags**

## Environment Variables

### Development (.env.dev)

- Uses local PostgreSQL
- Permissive CORS
- Debug logging enabled

### Production (.env.prod)

- Secure database credentials
- Restricted CORS
- Production logging
- SSL/TLS enabled

## Security Considerations

1. **Secrets Management:**

   - Use GitHub Secrets for sensitive values
   - Never commit real credentials
   - Rotate JWT secrets regularly

2. **Network Security:**

   - Internal Docker network for service communication
   - Expose only necessary ports
   - Use reverse proxy (Nginx) for SSL termination

3. **Image Security:**
   - Use Alpine-based images
   - Scan images for vulnerabilities
   - Use non-root users in containers

## Monitoring and Logging

1. **Health Checks:**

   - All services have health endpoints
   - Docker health checks configured
   - Automatic restart on failure

2. **Logging:**

   - Structured JSON logging
   - Centralized log collection
   - Log rotation configured

3. **Monitoring:**
   - Prometheus metrics
   - Grafana dashboards
   - Alert manager for notifications
