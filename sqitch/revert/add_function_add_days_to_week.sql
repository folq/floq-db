-- Revert floq:add_function_add_days_to_week from pg

BEGIN;

DROP FUNCTION IF EXISTS add_days_to_week(integer,text,integer,integer,integer);
DROP FUNCTION IF EXISTS week_to_date(integer,integer,integer);

COMMIT;
