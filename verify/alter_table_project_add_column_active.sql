-- Verify floq:alter_table_project_add_column_active on pg

BEGIN;

select active from projects;

ROLLBACK;
