# Postgres setup for ClinicaDent-ria backend

This file explains how to configure a local Postgres database for the backend and provides minimal SQL to create the tables the API expects.

1) Install Postgres

- Windows: https://www.postgresql.org/download/windows/
- Or use Docker: `docker run --name clinic-postgres -e POSTGRES_PASSWORD=changeme -e POSTGRES_USER=clinic_user -e POSTGRES_DB=clinicadent_db -p 5432:5432 -d postgres`

2) Create DB and user (example using psql)

psql -U postgres
CREATE USER clinic_user WITH PASSWORD 'changeme';
CREATE DATABASE clinicadent_db OWNER clinic_user;
\q

3) Set environment variables

Create a file named `.env` in `mobile/backend` and copy values from `.env.example`, replacing placeholders with your credentials. The app uses `DATABASE_URL` or the `DB_*` variables.

Example `.env`:

DB_HOST=localhost
DB_PORT=5432
DB_NAME=clinicadent_db
DB_USER=clinic_user
DB_PASSWORD=changeme
PORT=3001
JWT_SECRET=change_this_secret

4) Create tables the API expects

Run the following SQL in `clinicadent_db` (psql or a DB client):

-- usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  id SERIAL PRIMARY KEY,
  nome_completo TEXT,
  telefone TEXT,
  email TEXT UNIQUE NOT NULL,
  senha TEXT,
  role TEXT DEFAULT 'Paciente',
  data_nascimento DATE,
  genero TEXT,
  n_utente TEXT
);

-- refresh_tokens
CREATE TABLE IF NOT EXISTS refresh_tokens (
  token TEXT PRIMARY KEY,
  user_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
  expires_at TIMESTAMP WITHOUT TIME ZONE
);

-- password_resets
CREATE TABLE IF NOT EXISTS password_resets (
  user_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
  token TEXT,
  expires_at TIMESTAMP WITHOUT TIME ZONE
);

-- pacientes (basic fields used by the API)
CREATE TABLE IF NOT EXISTS pacientes (
  id SERIAL PRIMARY KEY,
  nome_completo TEXT,
  email TEXT,
  telefone TEXT,
  data_nascimento DATE,
  genero TEXT,
  n_utente TEXT,
  morada TEXT,
  notas TEXT,
  estado TEXT,
  seguro_principal_id INTEGER
);

5) Start the API

From `mobile/backend`:

Windows cmd.exe:
```cmd
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=clinicadent_db
set DB_USER=clinic_user
set DB_PASSWORD=changeme
node api.js
```

Or create `.env` and run:
```cmd
node api.js
```

6) Notes
- If you prefer, set `DATABASE_URL=postgres://user:pass@host:5432/dbname` instead of `DB_*` vars.
- The project includes a mock DB mode via `FORCE_DB_MOCK=1` (useful for development without a real Postgres).
- No migrations are included; the SQL above is minimal and may need expansion depending on production requirements.
