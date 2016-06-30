-- Verify floq:time_tracking_status_function on pg

BEGIN;

select * from time_tracking_status(current_date, current_date) limit 1;

ROLLBACK;
