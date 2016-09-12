-- Deploy floq:write_off_table to pg
-- requires: time_tracking_tables

BEGIN;

CREATE TABLE write_off (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  project TEXT NOT NULL REFERENCES projects(id),
  from_date DATE NOT NULL,  --inclusive
  to_date DATE NOT NULL, --exclusive
  minutes INTEGER NOT NULL -- consistent with time_entry
);

COMMIT;
