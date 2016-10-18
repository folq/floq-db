-- Verify floq:update_timetracking_status_function_alter_commit_date on pg

BEGIN;

SELECT has_function_privilege('unregistered_days(date,date,integer)', 'execute');
SELECT has_function_privilege('time_tracking_status(date,date)', 'execute');

ROLLBACK;
