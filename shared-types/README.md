# Shared Types

This package contains shared TypeScript types for the SFL (Survivor Fantasy League) microservices architecture.

## Features

- **Common Types**: Base response types, pagination, error handling
- **Service-Specific Types**: Auth and League domain types
- **Generated API Types**: Auto-generated from OpenAPI/Swagger specs
- **Type Safety**: Ensures consistency across microservices

## Installation

In each microservice, install the shared types:

```bash
# From the service directory
npm install ../shared-types
```

## Usage

```typescript
import { User, League, BaseResponse, SuccessResponse } from '@sfl/shared-types';

// Use the types in your service
const user: User = {
  id: 1,
  email: 'user@example.com',
  isEmailVerified: true,
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString()
};

const response: SuccessResponse<User> = {
  success: true,
  data: user,
  message: 'User retrieved successfully'
};
```

## Type Generation

Generate types from OpenAPI specs:

```bash
# Generate from running services
npm run generate

# Generate from local swagger.json files
npm run generate:local

# Generate specific service types
npm run generate:auth
npm run generate:league
npm run generate:gateway
```

## Scripts

- `npm run generate` - Generate all types from running services
- `npm run generate:local` - Generate from local swagger.json files
- `npm run build` - Build the package
- `npm run watch` - Build in watch mode

## Structure

```
src/
├── common.ts          # Common types used across all services
├── auth.ts           # Auth service domain types
├── league.ts         # League service domain types
├── generated/        # Auto-generated API types
│   ├── auth.ts
│   ├── league.ts
│   └── gateway.ts
└── index.ts          # Main export file
```

## Type Categories

### Common Types
- `BaseResponse<T>` - Standard API response wrapper
- `ErrorResponse` - Error response format
- `SuccessResponse<T>` - Success response format
- `PaginatedResponse<T>` - Paginated data response
- `HealthCheckResponse` - Service health check format

### Auth Types
- `User` - User entity
- `LoginRequest/Response` - Authentication
- `TokenPayload` - JWT token structure
- `AuthProvider` - OAuth provider data

### League Types
- `League` - League entity and settings
- `LeagueParticipant` - Participant data
- `Pick` - User picks for games
- Query and response types for league operations

## Development

1. Update types when APIs change
2. Run generation scripts to sync with OpenAPI specs
3. Version the package when making breaking changes
4. Update consuming services to use new types
