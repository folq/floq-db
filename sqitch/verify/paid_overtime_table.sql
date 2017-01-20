-- Verify floq:paid_overtime_table on pg

BEGIN;

SELECT * FROM paid_overtime WHERE FALSE;

ROLLBACK;
