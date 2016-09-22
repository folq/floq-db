-- Revert floq:upsert_write_off_function from pg

BEGIN;

DROP FUNCTION upsert_write_off(text,date,integer);

COMMIT;
