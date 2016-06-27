-- Verify floq:update_projects_function on pg

BEGIN;

select projects_for_employee_for_date(0);

ROLLBACK;
