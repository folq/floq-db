-- Verify floq:alter_reporting_visibility_remove_next_week_and_add_unavailable_hours on pg

BEGIN;

SELECT unavailable_hours from reporting_visibility;

ROLLBACK;
