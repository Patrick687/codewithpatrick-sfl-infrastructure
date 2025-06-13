# Environment Configuration Guide

This guide explains how to manage environment variables across different
environments in your microservices architecture.

## Environment Files Structure

Each service has multiple environment files for different scenarios:

### SFL Gateway

- `.env.dev` - Local development
- `.env.test` - Jest testing
- `.env.docker` - Docker development
- `.env.prod` - Production deployment

### Auth Service

- `.env.dev` - Local development
- `.env.test` - Jest testing
- `.env.docker` - Docker development
- `.env.prod` - Production deployment

## Usage

### Local Development

```bash
# Gateway
cd sfl_gateway
npm run dev

# Auth (in separate terminal)
cd auth
npm run dev
```

### Testing

```bash
# Gateway
cd sfl_gateway
npm test

# Auth
cd auth
npm test
```

### Docker Development

```bash
# From project root
docker-compose up --build

# Or for gateway only
cd sfl_gateway
npm run dev:docker
```

### Production Deployment

```bash
# Production with Docker
docker-compose -f docker-compose.prod.yml up --build

# Or build and start locally
cd sfl_gateway
npm run start:prod
```

## Environment Variables

### Required for SFL Gateway

- `NODE_ENV` - Environment type (development/test/docker/production)
- `JWT_SECRET` - Secret for JWT token validation
- `AUTH_SERVICE_URL` - URL to auth service

### Required for Auth Service

- `NODE_ENV` - Environment type
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` - Database
  connection
- `JWT_SECRET` - Secret for JWT token generation
- `SERVER_HOST`, `SERVER_PORT` - Server configuration

## Security Notes

⚠️ **IMPORTANT**: Before deploying to production:

1. Change all JWT secrets to strong, unique values
2. Update database passwords
3. Set proper CORS origins
4. Update Google OAuth credentials
5. Never commit `.env.prod` to version control

## Docker Networks

Services communicate through the `app-network` Docker network:

- Gateway → Auth: `http://auth:3001`
- Auth → Database: `http://auth_db:5432`

## Troubleshooting

### Service Can't Connect

- Check Docker network configuration
- Verify service URLs in environment files
- Ensure services are running in correct order

### Environment Not Loading

- Verify NODE_ENV is set correctly
- Check if environment file exists
- Confirm dotenv configuration in config files
