-- Deploy floq:alter_table_project_add_column_active to pg
-- requires: time_tracking_tables

BEGIN;

ALTER TABLE projects
  ADD COLUMN active boolean NOT NULL DEFAULT TRUE;

COMMIT;
