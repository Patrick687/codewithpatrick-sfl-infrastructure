-- This file will be automatically executed when the PostgreSQL container starts for the first time

-- Create databases first
CREATE DATABASE auth_db;
CREATE DATABASE league_db;

-- Create the auth_user if it doesn't exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'auth_user') THEN
      CREATE USER auth_user WITH PASSWORD 'auth_password';
   END IF;
END
$$;

-- Create the league_user if it doesn't exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'league_user') THEN
      CREATE USER league_user WITH PASSWORD 'league_password';
   END IF;
END
$$;

-- Grant all privileges on the auth_db database to auth_user
GRANT ALL PRIVILEGES ON DATABASE auth_db TO auth_user;

-- Grant all privileges on the league_db database to league_user
GRANT ALL PRIVILEGES ON DATABASE league_db TO league_user;

-- Connect to auth_db and set up privileges
\c auth_db;
CREATE EXTENSION IF NOT EXISTS citext;
GRANT ALL ON SCHEMA public TO auth_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO auth_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO auth_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO auth_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO auth_user;

-- Connect to league_db and set up privileges
\c league_db;
CREATE EXTENSION IF NOT EXISTS citext;
GRANT ALL ON SCHEMA public TO league_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO league_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO league_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO league_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO league_user;