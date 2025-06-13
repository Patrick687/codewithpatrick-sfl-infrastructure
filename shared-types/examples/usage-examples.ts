// Example of how to use shared types in your services
import { 
  User, 
  League, 
  BaseResponse, 
  SuccessResponse, 
  ErrorResponse, 
  LoginRequest,
  LoginResponse,
  CreateLeagueRequest,
  HealthCheckResponse,
  GatewayAPI
} from '../src/index';

// Example 1: Using common response types
export const createSuccessResponse = <T>(data: T, message?: string): SuccessResponse<T> => {
  return {
    success: true,
    data,
    message
  };
};

export const createErrorResponse = (error: string, message: string): ErrorResponse => {
  return {
    success: false,
    error,
    message
  };
};

// Example 2: Using auth types
export const handleLogin = async (request: LoginRequest): Promise<LoginResponse> => {
  // Your login logic here
  const user: User = {
    id: 1,
    email: request.email,
    isEmailVerified: true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  return {
    user,
    tokens: {
      accessToken: 'jwt-token-here',
      expiresIn: 3600
    }
  };
};

// Example 3: Using league types
export const createLeague = async (request: CreateLeagueRequest, userId: number): Promise<League> => {
  const league: League = {
    id: 1,
    name: request.name,
    description: request.description,
    season: request.season,
    maxParticipants: request.maxParticipants,
    currentParticipants: 0,
    isActive: true,
    startDate: request.startDate,
    endDate: request.endDate,
    createdBy: userId,
    settings: request.settings,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  return league;
};

// Example 4: Using generated API types
export const callGatewayAPI = async (): Promise<HealthCheckResponse> => {
  // You can use the generated path types for type-safe API calls
  // This ensures your API calls match your OpenAPI spec
  
  const response = await fetch('/health');
  const data: HealthCheckResponse = await response.json();
  return data;
};

// Example 5: Type-safe middleware
export const validateCreateLeagueRequest = (body: any): body is CreateLeagueRequest => {
  return (
    typeof body === 'object' &&
    typeof body.name === 'string' &&
    typeof body.season === 'number' &&
    typeof body.maxParticipants === 'number' &&
    typeof body.startDate === 'string' &&
    typeof body.settings === 'object'
  );
};

// Example 6: Using the types in Express route handlers
export const getUserProfile = async (userId: number): Promise<SuccessResponse<User> | ErrorResponse> => {
  try {
    // Your database call here
    const user: User = {
      id: userId,
      email: 'user@example.com',
      isEmailVerified: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    return createSuccessResponse(user, 'User profile retrieved successfully');
  } catch (error) {
    return createErrorResponse('USER_NOT_FOUND', 'User not found');
  }
};
