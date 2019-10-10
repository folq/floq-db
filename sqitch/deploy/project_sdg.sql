-- Deploy floq:project_sdg to pg

BEGIN;

CREATE TABLE project_sdg_events (
  event_id SERIAL PRIMARY KEY,
  event_type TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  caused_by INTEGER NOT NULL REFERENCES employees(id),
  project TEXT NOT NULL REFERENCES projects(id),
  goal INTEGER NOT NULL
);

COMMIT;
