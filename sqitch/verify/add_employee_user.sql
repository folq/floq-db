-- Verify floq:add_employee_user on pg

BEGIN;

-- divide-by-zero if user does not exist
SELECT 1/COUNT(*) FROM pg_catalog.pg_user
WHERE usename = 'employee' AND passwd IS NOT NULL;

ROLLBACK;
