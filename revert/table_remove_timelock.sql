-- Revert floq:table_remove_timelock from pg

BEGIN;

CREATE TABLE timelock (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  employee integer NOT NULL REFERENCES employees(id),
  commit_date DATE NOT NULL, -- The commit_date column specifies which date and all previous date you have comitted / are done registering hours.
  created TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (employee, created)
);

COMMIT;
