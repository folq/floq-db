-- Verify floq:employees_table on pg

BEGIN;

SELECT * FROM employees WHERE FALSE;

ROLLBACK;
