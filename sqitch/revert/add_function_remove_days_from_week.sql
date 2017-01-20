-- Revert floq:add_function_remove_days_from_week from pg

BEGIN;

DROP FUNCTION IF EXISTS remove_days_from_week(integer,text,integer,integer,integer);

COMMIT;
