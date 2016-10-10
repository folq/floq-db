-- Verify floq:update_timetracking_status_function_add_commit_date on pg

BEGIN;

SELECT has_function_privilege('hours_per_project(date,date)', 'execute');

ROLLBACK;
