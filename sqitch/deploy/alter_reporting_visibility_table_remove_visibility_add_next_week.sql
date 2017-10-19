-- Deploy floq:alter_reporting_visibility_table_remove_visibility_add_next_week to pg

BEGIN;

ALTER TABLE reporting_visibility 
    DROP COLUMN IF EXISTS visibility
ALTER TABLE reporting_visibility
    ADD COLUMN next_week_available_hours NUMERIC NOT NULL
ALTER TABLE reporting_visibility
    ADD COLUMN next_week_billable_hours NUMERIC NOT NULL

COMMIT;
