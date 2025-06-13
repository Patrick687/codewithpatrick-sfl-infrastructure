// League-specific types
import { TimestampFields, PaginationParams, PaginatedResponse } from './common';

// League types
export interface League extends TimestampFields {
  id: number;
  name: string;
  description?: string;
  season: number;
  maxParticipants: number;
  currentParticipants: number;
  isActive: boolean;
  startDate: string;
  endDate?: string;
  createdBy: number;
  settings: LeagueSettings;
}

export interface LeagueSettings {
  eliminationRules: 'single' | 'double' | 'triple';
  weeklyPickDeadline: string; // ISO time format, e.g., "2024-12-15T18:00:00Z"
  allowLateEntry: boolean;
  publicLeague: boolean;
  entryFee?: number;
  prizeStructure?: PrizeStructure[];
}

export interface PrizeStructure {
  position: number;
  prize: string | number;
  type: 'cash' | 'trophy' | 'other';
}

export interface CreateLeagueRequest {
  name: string;
  description?: string;
  season: number;
  maxParticipants: number;
  startDate: string;
  endDate?: string;
  settings: LeagueSettings;
}

export interface UpdateLeagueRequest {
  name?: string;
  description?: string;
  maxParticipants?: number;
  startDate?: string;
  endDate?: string;
  settings?: Partial<LeagueSettings>;
}

// Participant types
export interface LeagueParticipant extends TimestampFields {
  id: number;
  leagueId: number;
  userId: number;
  isEliminated: boolean;
  eliminationWeek?: number;
  strikes: number;
  joinDate: string;
  user?: {
    id: number;
    email: string;
    firstName?: string;
    lastName?: string;
  };
}

export interface JoinLeagueRequest {
  leagueId: number;
  inviteCode?: string;
}

// Pick types
export interface Pick extends TimestampFields {
  id: number;
  participantId: number;
  leagueId: number;
  week: number;
  team: string;
  isLocked: boolean;
  isCorrect?: boolean;
  gameDate: string;
}

export interface CreatePickRequest {
  leagueId: number;
  week: number;
  team: string;
}

export interface UpdatePickRequest {
  team: string;
}

// Query types
export interface GetLeaguesQuery extends PaginationParams {
  search?: string;
  season?: number;
  isActive?: boolean;
  createdBy?: number;
}

export interface GetParticipantsQuery extends PaginationParams {
  leagueId: number;
  isEliminated?: boolean;
}

export interface GetPicksQuery extends PaginationParams {
  leagueId?: number;
  participantId?: number;
  week?: number;
}

// Response types
export type GetLeaguesResponse = PaginatedResponse<League>;
export type GetParticipantsResponse = PaginatedResponse<LeagueParticipant>;
export type GetPicksResponse = PaginatedResponse<Pick>;
