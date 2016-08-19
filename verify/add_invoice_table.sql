-- Verify floq:add_invoice_table on pg

BEGIN;

SELECT * FROM invoice WHERE FALSE;

ROLLBACK;
