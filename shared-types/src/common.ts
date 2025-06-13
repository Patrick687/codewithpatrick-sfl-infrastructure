// Common types used across all services
export interface BaseResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export interface ErrorResponse {
  success: false;
  error: string;
  message: string;
  statusCode?: number;
}

export interface SuccessResponse<T = any> {
  success: true;
  data: T;
  message?: string;
}

// Pagination types
export interface PaginationParams {
  page?: number;
  limit?: number;
  offset?: number;
}

export interface PaginationMeta {
  currentPage: number;
  itemsPerPage: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface PaginatedResponse<T> extends SuccessResponse<T[]> {
  meta: PaginationMeta;
}

// Common field types
export interface TimestampFields {
  createdAt: string;
  updatedAt: string;
}

export interface OptionalTimestampFields {
  createdAt?: string;
  updatedAt?: string;
  deletedAt?: string;
}

// Health check response
export interface HealthCheckResponse {
  status: 'ok' | 'error';
  timestamp: string;
  service: string;
  version: string;
  uptime?: number;
  dependencies?: Record<string, 'healthy' | 'unhealthy'>;
}
