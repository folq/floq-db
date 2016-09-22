-- Verify floq:upsert_write_off_function on pg

BEGIN;

SELECT has_function_privilege('upsert_write_off(text,date,integer)', 'execute');

ROLLBACK;
