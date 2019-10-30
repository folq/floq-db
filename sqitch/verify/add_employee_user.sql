-- Verify floq:add_employee_user on pg

BEGIN;

ASSERT SELECT COUNT(*) = 1
FROM pg_catalog.pg_user
WHERE username = 'employee'
  AND password != NULL;

ROLLBACK;
