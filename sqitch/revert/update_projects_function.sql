-- Revert floq:update_projects_function from pg

BEGIN;

-- Fallthrough to time_tracking_functions for dropping function: projects_for_employee_for_date

COMMIT;
