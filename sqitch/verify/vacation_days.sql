-- Verify floq:vacation_days on pg

BEGIN;

SELECT * FROM employee_years WHERE FALSE;
SELECT * FROM vacation_days_by_year WHERE FALSE;
SELECT * FROM vacation_days_spent WHERE FALSE;
SELECT * FROM vacation_days_earnt WHERE FALSE;
SELECT * FROM vacation_days WHERE FALSE;

ROLLBACK;
