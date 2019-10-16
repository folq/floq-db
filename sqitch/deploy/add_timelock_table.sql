-- Deploy floq:add_timelock_table to pg
-- requires: employees_table

BEGIN;

CREATE TABLE timelock_events (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  created TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  creator INTEGER NOT NULL REFERENCES employees(id),

  employee INTEGER NOT NULL REFERENCES employees(id),
  commit_date DATE NOT NULL
);

CREATE INDEX timelock_events_commit_date_index ON timelock_events USING BRIN (commit_date);

CREATE MATERIALIZED VIEW timelock_view AS
  WITH tl AS (
    SELECT *, row_number() over(PARTITION BY employee ORDER BY created DESC) as row_number
    FROM timelock_events
  )
  SELECT id, created, creator, employee, commit_date
  FROM tl
  WHERE row_number = 1;

CREATE UNIQUE INDEX ON timelock_view (employee);

COMMIT;
