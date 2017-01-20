-- Revert floq:alter_table_project_add_column_active from pg

BEGIN;

ALTER TABLE projects
  DROP COLUMN active;

COMMIT;
