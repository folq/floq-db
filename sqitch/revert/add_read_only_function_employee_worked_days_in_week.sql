-- Revert floq:add_read_only_function_employee_worked_days_in_week from pg

BEGIN;

DROP FUNCTION IF EXISTS employee_worked_days_per_week(integer,date,integer);

COMMIT;
