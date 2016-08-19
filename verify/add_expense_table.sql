-- Verify floq:add_expense_table on pg

BEGIN;

SELECT * FROM expense WHERE FALSE;

ROLLBACK;
