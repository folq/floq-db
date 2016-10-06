-- Verify floq:table_timelock on pg

BEGIN;

SELECT id from employees WHERE false;
SELECT id, employee, commit_date, created FROM timelock WHERE false;

ROLLBACK;
