-- Revert floq:time_tracking_status_function from pg

BEGIN;

drop function time_tracking_status(date, date);

COMMIT;
