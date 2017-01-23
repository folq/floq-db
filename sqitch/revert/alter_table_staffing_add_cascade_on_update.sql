-- Revert floq:alter_table_staffing_add_cascade_on_update from pg

BEGIN;

ALTER TABLE public.staffing
  DROP CONSTRAINT staffing_project_fkey,
  ADD CONSTRAINT staffing_project_fkey FOREIGN KEY (project)
      REFERENCES public.projects (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE public.staffing
  DROP CONSTRAINT staffing_employee_fkey,
  ADD CONSTRAINT staffing_employee_fkey FOREIGN KEY (employee)
      REFERENCES public.employees (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMIT;
