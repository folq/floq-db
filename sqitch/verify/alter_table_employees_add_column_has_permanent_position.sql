-- Verify floq:alter_table_employees_add_column_has_permanent_position on pg

BEGIN;

SELECT has_permanent_position FROM employees;
 
ROLLBACK;
