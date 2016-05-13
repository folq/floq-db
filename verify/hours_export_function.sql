-- Verify floq:hours_export_function on pg

BEGIN;

select * from hours_per_employee(current_date, current_date);

ROLLBACK;
