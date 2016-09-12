-- Revert floq:write_off_table from pg

BEGIN;

DROP TABLE write_off;

COMMIT;
