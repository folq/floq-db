-- Verify floq:upsert_invoice_status_function on pg

BEGIN;

SELECT has_function_privilege('upsert_invoice_status(text, date, text)', 'execute');

ROLLBACK;
