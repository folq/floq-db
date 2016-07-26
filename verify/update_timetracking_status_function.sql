-- Verify floq:update_timetracking_status_function on pg

BEGIN;

select * from time_tracking_status('2016-07-01', '2016-07-31') limit 1;

ROLLBACK;
