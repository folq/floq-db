-- Deploy floq:revoke_write_grants_on_employee_role_from_employee to pg

BEGIN;

REVOKE INSERT ON TABLE employee_role FROM employee;
REVOKE UPDATE ON TABLE employee_role FROM employee;
REVOKE DELETE ON TABLE employee_role FROM employee;

COMMIT;
