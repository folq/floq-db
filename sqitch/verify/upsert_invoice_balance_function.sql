-- Verify floq:upsert_invoice_balance_function on pg

BEGIN;

SELECT has_function_privilege('upsert_invoice_balance(text, date, integer, numeric)', 'execute');

ROLLBACK;
