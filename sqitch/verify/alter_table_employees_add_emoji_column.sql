-- Verify floq:alter_table_employees_add_emoji_column on pg

BEGIN;

SELECT emojio FROM employees;

ROLLBACK;
