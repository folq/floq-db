-- Revert floq:add_timelock_table from pg

BEGIN;

DROP INDEX timelock_commit_date_index;
DROP TABLE timelock;

COMMIT;
