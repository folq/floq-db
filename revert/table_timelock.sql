-- Revert floq:table_timelock from pg

BEGIN;

DROP TABLE timelock;

COMMIT;
