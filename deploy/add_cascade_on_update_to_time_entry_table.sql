-- Deploy floq:add_cascade_on_update_to_time_entry_table to pg

BEGIN;

ALTER TABLE time_entry
  DROP CONSTRAINT time_entry_project_fkey,
  ADD CONSTRAINT time_entry_project_fkey FOREIGN KEY (project)
        REFERENCES projects (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE NO ACTION;

COMMIT;
