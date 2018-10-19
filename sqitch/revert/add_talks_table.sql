-- Revert floq:add_talks_table from pg

BEGIN;

DROP TABLE talks;

COMMIT;
