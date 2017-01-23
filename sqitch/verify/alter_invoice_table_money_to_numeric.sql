-- Verify floq:alter_invoice_table_money_to_numeric on pg

BEGIN;

SELECT * FROM invoice_balance WHERE FALSE;
select amount::float from invoice_balance

ROLLBACK;
