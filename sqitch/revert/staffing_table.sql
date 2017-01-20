-- Revert floq:staffing_table from pg

BEGIN;

DROP TABLE staffing;

COMMIT;
