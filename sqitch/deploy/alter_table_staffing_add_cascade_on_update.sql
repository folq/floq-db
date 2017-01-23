-- Deploy floq:alter_table_staffing_add_cascade_on_update to pg
-- requires: staffing_table

BEGIN;

ALTER TABLE staffing
  DROP CONSTRAINT staffing_project_fkey,
  ADD CONSTRAINT staffing_project_fkey FOREIGN KEY (project)
      REFERENCES projects (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE staffing
  DROP CONSTRAINT staffing_employee_fkey,
  ADD CONSTRAINT staffing_employee_fkey FOREIGN KEY (employee)
      REFERENCES employees (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;

COMMIT;
