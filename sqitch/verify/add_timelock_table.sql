-- Verify floq:add_timelock_table on pg

BEGIN;

SELECT * FROM timelock_events WHERE false;
SELECT * FROM timelock_view WHERE false;

ROLLBACK;
