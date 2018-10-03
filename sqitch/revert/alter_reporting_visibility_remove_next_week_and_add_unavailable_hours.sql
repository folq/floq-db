-- Revert floq:alter_reporting_visibility_remove_next_week_and_add_unavailable_hours from pg

BEGIN;

ALTER TABLE reporting_visibility
    ADD COLUMN next_week_available_hours NUMERIC NOT NULL;
ALTER TABLE reporting_visibility
    ADD COLUMN next_week_billable_hours NUMERIC NOT NULL;
ALTER TABLE reporting_visibility 
    DROP COLUMN IF EXISTS unavailable_hours;

COMMIT;
