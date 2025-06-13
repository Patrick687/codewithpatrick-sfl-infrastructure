# Integration Guide: Using Shared Types

This guide shows how to integrate the shared types package into your SFL microservices.

## 1. Installation

In each service directory, install the shared types:

```bash
cd sfl_gateway
npm install ../shared-types

cd ../sfl_authService  
npm install ../shared-types

cd ../sfl_leagueService
npm install ../shared-types
```

## 2. Basic Usage in Services

### Gateway Service Example

```typescript
// sfl_gateway/src/types/api.ts
import { SuccessResponse, ErrorResponse, HealthCheckResponse } from '@sfl/shared-types';

export const createAPIResponse = <T>(data: T, message?: string): SuccessResponse<T> => ({
  success: true,
  data,
  message
});

export const createAPIError = (error: string, message: string): ErrorResponse => ({
  success: false,
  error,
  message
});
```

### Auth Service Example

```typescript
// sfl_authService/src/controllers/authController.ts
import { User, LoginRequest, LoginResponse, CreateUserRequest } from '@sfl/shared-types';
import { Request, Response } from 'express';

export const login = async (req: Request<{}, LoginResponse, LoginRequest>, res: Response) => {
  try {
    const { email, password } = req.body;
    
    // Your authentication logic
    const user: User = await authenticateUser(email, password);
    const tokens = await generateTokens(user);
    
    const response: LoginResponse = {
      user,
      tokens
    };
    
    res.json(response);
  } catch (error) {
    res.status(401).json({
      success: false,
      error: 'AUTHENTICATION_FAILED',
      message: 'Invalid credentials'
    });
  }
};
```

### League Service Example

```typescript
// sfl_leagueService/src/controllers/leagueController.ts
import { League, CreateLeagueRequest, SuccessResponse } from '@sfl/shared-types';
import { Request, Response } from 'express';

export const createLeague = async (
  req: Request<{}, SuccessResponse<League>, CreateLeagueRequest>, 
  res: Response
) => {
  try {
    const leagueData = req.body;
    const userId = req.user?.id; // From auth middleware
    
    const league: League = await leagueService.create({
      ...leagueData,
      createdBy: userId,
      currentParticipants: 0,
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    });
    
    res.status(201).json({
      success: true,
      data: league,
      message: 'League created successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'LEAGUE_CREATION_FAILED',
      message: 'Failed to create league'
    });
  }
};
```

## 3. Type Generation Workflow

### Development Workflow

1. **Start all services** in development mode:
   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```

2. **Generate types** from running services:
   ```bash
   cd shared-types
   npm run generate
   ```

3. **Build the shared types package**:
   ```bash
   npm run build
   ```

4. **Update services** to use new types (no reinstall needed for local packages)

### CI/CD Integration

Add to your deployment pipeline:

```yaml
# .github/workflows/ci.yml
- name: Generate Types
  run: |
    cd shared-types
    npm install
    npm run generate
    npm run build
    
- name: Update Services
  run: |
    cd sfl_gateway && npm ci
    cd ../sfl_authService && npm ci  
    cd ../sfl_leagueService && npm ci
```

## 4. Best Practices

### 1. Version Management
- Update the shared-types version when making breaking changes
- Use semantic versioning
- Document changes in CHANGELOG.md

### 2. Type Safety
- Use the generated API types for HTTP client calls
- Validate request/response data against the types
- Use TypeScript strict mode

### 3. API Evolution
- Generate new types after API changes
- Test all services after type updates
- Use optional properties for backward compatibility

### 4. Development Tips
- Keep generated types in version control
- Regenerate types when APIs change
- Use type guards for runtime validation

## 5. Example Service Structure

```
sfl_gateway/
├── src/
│   ├── types/
│   │   ├── api.ts          # Shared type utilities
│   │   └── requests.ts     # Request/response helpers
│   ├── controllers/
│   ├── middleware/
│   └── index.ts
└── package.json            # includes @sfl/shared-types

sfl_authService/
├── src/
│   ├── types/
│   │   ├── auth.ts         # Auth-specific type extensions
│   │   └── validation.ts   # Type validation helpers
│   ├── controllers/
│   ├── services/
│   └── index.ts
└── package.json            # includes @sfl/shared-types
```

## 6. Testing with Types

```typescript
// Example test with types
import { User, LoginResponse } from '@sfl/shared-types';

describe('Auth API', () => {
  it('should return properly typed login response', async () => {
    const response = await request(app)
      .post('/auth/login')
      .send({ email: 'test@example.com', password: 'password' });
    
    // TypeScript will validate the response structure
    const loginResponse: LoginResponse = response.body;
    
    expect(loginResponse.user).toBeDefined();
    expect(loginResponse.tokens.accessToken).toBeDefined();
    expect(typeof loginResponse.user.id).toBe('number');
  });
});
```

This approach ensures type safety across your entire microservices architecture while maintaining flexibility for individual service development.
