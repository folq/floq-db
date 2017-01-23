-- Deploy floq:staffing_table to pg
-- requires: employees_table
-- requires: time_tracking_tables
-- requires: change_projects_id_to_text

BEGIN;

CREATE TABLE staffing (
  employee INTEGER NOT NULL REFERENCES employees(id),
  project TEXT NOT NULL REFERENCES projects(id),
  date DATE NOT NULL,
  PRIMARY KEY (employee, date)
);

COMMIT;
