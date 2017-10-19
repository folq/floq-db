-- Verify floq:alter_reporting_visibility_table_remove_visibility_add_next_week on pg

BEGIN;

SELECT next_week_available_hours from reporting_visibility;

ROLLBACK;
