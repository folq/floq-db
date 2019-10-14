-- Verify floq:add_timelock_table on pg

BEGIN;

SELECT id from employees WHERE false;
SELECT id, employee, commit_date, created FROM timelock WHERE false;

ROLLBACK;
