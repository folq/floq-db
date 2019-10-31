-- Revert floq:revoke_write_grants_on_employee_role_from_employee from pg

BEGIN;

GRANT ALL PRIVILEGES ON TABLE employee_role TO employee;

COMMIT;
