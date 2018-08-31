-- Verify floq:vacation_days on pg

BEGIN;

SELECT * FROM vacation_days WHERE FALSE;

ROLLBACK;
