-- Deploy floq:alter_reporting_visibility_remove_next_week_and_add_unavailable_hours to pg

BEGIN;

ALTER TABLE reporting_visibility 
    DROP COLUMN IF EXISTS next_week_available_hours;
ALTER TABLE reporting_visibility 
    DROP COLUMN IF EXISTS next_week_billable_hours;
ALTER TABLE reporting_visibility
    ADD COLUMN unavailable_hours NUMERIC NOT NULL;

COMMIT;
