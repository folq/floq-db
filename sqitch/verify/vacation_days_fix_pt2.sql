-- Verify floq:vacation_days_fix_pt2 on pg

BEGIN;

SELECT * FROM employee_years WHERE FALSE;

ROLLBACK;
