-- Verify floq:vacation_days_fix on pg

BEGIN;

SELECT * FROM employee_years WHERE FALSE;

ROLLBACK;
