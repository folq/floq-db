-- Verify floq:update_hours_per_project_function_add_invoice_status on pg

BEGIN;

SELECT has_function_privilege('hours_per_project(date,date)', 'execute');

ROLLBACK;
