-- Revert floq:add_timelock_table from pg

BEGIN;

DROP TABLE timelock;

COMMIT;
