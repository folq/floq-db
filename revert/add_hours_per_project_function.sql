-- Revert floq:add_hours_per_project_function from pg

BEGIN;

DROP FUNCTION IF EXISTS hours_per_project(in_start_date date, in_end_date date);

COMMIT;
