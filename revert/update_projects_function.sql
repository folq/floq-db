-- Revert floq:update_projects_function from pg

BEGIN;

drop function projects_for_employee_for_date(integer, date);

COMMIT;
