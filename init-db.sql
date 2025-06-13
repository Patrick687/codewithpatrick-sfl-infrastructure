-- This file will be automatically executed when the PostgreSQL container starts for the first time

-- Create the auth_user if it doesn't exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'auth_user') THEN
      CREATE USER auth_user WITH PASSWORD 'auth_password';
   END IF;
END
$$;

-- Grant all privileges on the auth_db database to auth_user
GRANT ALL PRIVILEGES ON DATABASE auth_db TO auth_user;

-- Grant privileges on the public schema
GRANT ALL ON SCHEMA public TO auth_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO auth_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO auth_user;

-- Ensure future tables/sequences are also granted
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO auth_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO auth_user;