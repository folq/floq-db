-- Revert floq:alter_reporting_visibility_table_remove_visibility_add_next_week from pg

BEGIN;
ALTER TABLE reporting_visibility 
    ADD COLUMN visibility NUMERIC NOT NULL
ALTER TABLE reporting_visibility
    DROP COLUMN IF EXISTS next_week_available_hours
ALTER TABLE reporting_visibility
    DROP COLUMN IF EXISTS next_week_billable_hours
COMMIT;