-- Deploy floq:alter_table_project_add_column_responsible to pg
-- requires: time_tracking_tables
-- requires: employees_table

BEGIN;

ALTER TABLE projects
  ADD COLUMN responsible integer,
  ADD CONSTRAINT projects_employees_fkey FOREIGN KEY (responsible)
      REFERENCES employees (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;

COMMIT;
