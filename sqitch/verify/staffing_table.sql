-- Verify floq:staffing_table on pg

BEGIN;

SELECT * FROM staffing WHERE FALSE;

ROLLBACK;
