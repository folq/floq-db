-- Revert floq:alter_table_project_add_column_responsible from pg

BEGIN;

ALTER TABLE projects
  DROP COLUMN responsible;

COMMIT;
