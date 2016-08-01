-- Revert floq:add_read_only_function_worked_days_per_week from pg

BEGIN;

DROP FUNCTION IF EXISTS worked_days_per_week(integer,integer,integer);

COMMIT;
