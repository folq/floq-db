-- Verify floq:alter_table_employeees_add_bio_and_role_column on pg

BEGIN;

SELECT "role" FROM employees;

SELECT bio FROM employees;

ROLLBACK;

