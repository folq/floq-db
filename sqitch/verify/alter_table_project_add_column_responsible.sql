-- Verify floq:alter_table_project_add_column_responsible on pg

BEGIN;

select id, responsible from projects;
select id from employees;

ROLLBACK;
