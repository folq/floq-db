-- Revert floq:employee_role from pg

BEGIN;

DROP TABLE IF EXISTS employee_role;
DROP TYPE IF EXISTS employee_role_type;

COMMIT;
