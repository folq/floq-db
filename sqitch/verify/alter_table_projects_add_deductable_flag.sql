-- Verify floq:alter_table_projects_add_skattefunn_flag on pg

BEGIN;

-- XXX Add verifications here.
SELECT deductable FROM projects;

ROLLBACK;
