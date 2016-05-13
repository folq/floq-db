-- Revert floq:hours_export_function from pg

BEGIN;

drop function hours_per_employee(date, date);

COMMIT;
