-- Verify floq:return_email_from_timetracking_status_function on pg

BEGIN;

select email from time_tracking_status(current_date, current_date);

ROLLBACK;
