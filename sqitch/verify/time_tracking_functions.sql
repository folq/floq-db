-- Verify floq:time_tracking_functions on pg

BEGIN;

select projects_for_employee_for_date(0);
select entries_sums_for_employee(0);

ROLLBACK;
