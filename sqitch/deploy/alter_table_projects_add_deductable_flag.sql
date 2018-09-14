-- Deploy floq:alter_table_projects_add_skattefunn_flag to pg

BEGIN;

ALTER TABLE projects ADD COLUMN "deductable" boolean DEFAULT false;

COMMIT;
