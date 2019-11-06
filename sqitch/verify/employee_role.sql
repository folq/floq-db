-- Verify floq:employee_role on pg

BEGIN;

INSERT INTO employees(id, first_name, last_name, phone, email, gender, birth_date, title)
VALUES (-77, 'Admin', 'Istrator', '11223344', 'admin@blank.no', 'male', '1970-01-01', 'title');

INSERT INTO employee_role(employee_id, role_type)
VALUES (-77, 'admin');

SELECT id, employee_id, role_type, created
FROM employee_role;

ROLLBACK;