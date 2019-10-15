-- Verify floq:add_timelock_table on pg

BEGIN;

SELECT * FROM timelock WHERE false;

ROLLBACK;
