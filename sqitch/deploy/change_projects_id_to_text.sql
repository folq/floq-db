-- Deploy floq:change_projects_id_to_text to pg

BEGIN;

ALTER TABLE time_entry
  DROP CONSTRAINT time_entry_project_fkey,
  ALTER COLUMN project TYPE text;

ALTER TABLE projects
  ALTER COLUMN id DROP DEFAULT,
  ALTER COLUMN id TYPE text;

ALTER TABLE time_entry
  ADD CONSTRAINT time_entry_project_fkey FOREIGN KEY (project)
        REFERENCES projects (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMIT;
