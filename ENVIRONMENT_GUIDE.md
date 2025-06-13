# Environment Variable Management Guide

This project uses centralized environment variable management at the root level for all Docker Compose workflows.

## 📁 File Structure

```
/
├── .env.dev.template      # Development environment template (versioned)
├── .env.prod.template     # Production environment template (versioned)
├── .env.dev.local         # Development environment secrets (ignored by git)
├── .env.prod.local        # Production environment secrets (ignored by git)
├── docker-compose.yml     # Base PostgreSQL configuration
├── docker-compose.dev.yml # Development services
├── docker-compose.prod.yml # Production services
└── scripts/
    ├── dev-up.sh          # Start development environment
    ├── prod-up.sh         # Start production environment
    └── db-only.sh         # Start database only for local development
```

## 🚀 Quick Start

### First Time Setup

1. **Copy environment templates:**
   ```bash
   cp .env.dev.template .env.dev.local
   cp .env.prod.template .env.prod.local
   ```

2. **Configure your environment files:**
   - Edit `.env.dev.local` with development values
   - Edit `.env.prod.local` with production values (use strong passwords!)

3. **Start your environment:**
   ```bash
   # Development (with hot reload)
   ./scripts/dev-up.sh
   
   # Production
   ./scripts/prod-up.sh
   
   # Database only (for local development)
   ./scripts/db-only.sh
   ```

## 🏗️ Environment Configurations

### Development Environment (`.env.dev.local`)
- Uses weak passwords for convenience
- Includes debug logging
- Hot reload volumes mounted
- Dev-specific OAuth settings

### Production Environment (`.env.prod.local`)
- **Must use strong, secure passwords**
- Minimal logging
- No volume mounts
- Production OAuth settings

## 🔐 Security Notes

### ✅ Safe to Version Control
- `.env.*.template` files - These are templates with placeholder values
- `docker-compose.*.yml` files - These reference environment variables

### ❌ Never Version Control
- `.env.*.local` files - These contain actual secrets
- Any file with real passwords, API keys, or tokens

### 🛡️ Security Best Practices

1. **Use strong passwords in production**
2. **Rotate secrets regularly**
3. **Use different secrets for each environment**
4. **Never commit real secrets to git**

## 🎯 Available Scripts

| Script | Purpose | Environment File |
|--------|---------|------------------|
| `./scripts/dev-up.sh` | Full development stack | `.env.dev.local` |
| `./scripts/prod-up.sh` | Full production stack | `.env.prod.local` |
| `./scripts/db-only.sh` | Database only | `.env.dev.local` |

## 🚀 Service URLs (Default)

| Service | Development | Production |
|---------|-------------|------------|
| Gateway | http://localhost:3000 | http://localhost:3000 |
| Auth Service | http://localhost:3001 | http://localhost:3001 |
| League Service | http://localhost:3002 | http://localhost:3002 |
| PostgreSQL | localhost:5432 | localhost:5432 |

## 🔧 Environment Variables Reference

### Database Configuration
- `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` - Main PostgreSQL
- `AUTH_DB_*` - Auth service database settings
- `LEAGUE_DB_*` - League service database settings

### Service Configuration
- `AUTH_SERVER_*` - Auth service settings
- `LEAGUE_SERVER_*` - League service settings
- `GATEWAY_*` - Gateway service settings

### Security
- `JWT_SECRET` - JWT signing secret
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` - OAuth settings

### Cross-Service Communication
- `AUTH_SERVICE_URL` - How other services reach auth
- `CORS_ORIGIN` - Allowed frontend origins

## 🔄 Migration from Individual Service .env Files

If you have individual `.env` files in service directories:

1. **For Docker Compose workflows:** Remove them, use root-level files
2. **For local development:** Keep them, or use local environment variables
3. **For testing:** Keep service-specific `.env.test` files

## 🆘 Troubleshooting

### Environment file not found
```bash
# Make sure you've copied the template
cp .env.dev.template .env.dev.local
```

### Services can't connect
- Check service names in environment variables match Docker Compose service names
- Ensure all required environment variables are set

### Permission denied on scripts
```bash
chmod +x scripts/*.sh
```
