-- Deploy floq:add_timelock_table to pg
-- requires: employees_table

BEGIN;

CREATE TABLE timelock (
  id SERIAL PRIMARY KEY,
  employee INTEGER NOT NULL REFERENCES employees(id),
  creator INTEGER NOT NULL REFERENCES employees(id),
  commit_date DATE NOT NULL,
  created TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE INDEX timelock_commit_date_index ON timelock USING BRIN (commit_date);

COMMIT;
