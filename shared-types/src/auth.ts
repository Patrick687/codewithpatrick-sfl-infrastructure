// Auth-specific types that are commonly used across services
import { TimestampFields, OptionalTimestampFields } from './common';

// User types
export interface User extends TimestampFields {
  id: string; // Changed from number to string for UUID compatibility
  email: string;
  isEmailVerified: boolean;
  firstName?: string;
  lastName?: string;
  profilePicture?: string;
}

export interface CreateUserRequest {
  email: string;
  password: string;
  confirmPassword: string;
  firstName?: string;
  lastName?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
  confirmNewPassword: string;
}

// Token types
export interface TokenPayload {
  userId: string; // Changed from number to string for UUID compatibility
  email: string;
  iat?: number;
  exp?: number;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken?: string;
  expiresIn: number;
}

export interface LoginResponse {
  user: Omit<User, 'password'>;
  tokens: AuthTokens;
}

// OAuth types
export interface GoogleProfile {
  id: string;
  email: string;
  name: string;
  picture?: string;
  given_name?: string;
  family_name?: string;
  verified_email?: boolean;
}

export interface AuthProvider extends TimestampFields {
  id: string; // Changed from number to string for UUID compatibility
  userId: string; // Changed from number to string for UUID compatibility
  provider: 'google' | 'facebook' | 'github' | 'local';
  providerId?: string;
  providerData?: Record<string, any>;
}

// Validation error types
export interface ValidationError {
  field: string;
  message: string;
  value?: any;
}

export interface ValidationErrorResponse {
  success: false;
  error: 'VALIDATION_ERROR';
  message: string;
  details: ValidationError[];
}
