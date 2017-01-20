-- Verify floq:add_holidays_table on pg

BEGIN;

SELECT * FROM holidays WHERE FALSE;

ROLLBACK;
