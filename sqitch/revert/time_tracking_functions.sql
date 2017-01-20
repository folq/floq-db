-- Revert floq:time_tracking_functions from pg

BEGIN;

drop function projects_for_employee_for_date(integer, date);
drop function entries_sums_for_employee(integer, date, integer);

COMMIT;
