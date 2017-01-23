-- Revert floq:change_projects_id_to_text from pg

BEGIN;

ALTER TABLE time_entry
  DROP CONSTRAINT time_entry_project_fkey,
  ALTER COLUMN project TYPE integer USING (project::integer);

ALTER TABLE projects
  ALTER COLUMN id TYPE integer USING (id::integer),
  ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);

ALTER TABLE time_entry
  ADD CONSTRAINT time_entry_project_fkey FOREIGN KEY (project)
        REFERENCES projects (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMIT;
