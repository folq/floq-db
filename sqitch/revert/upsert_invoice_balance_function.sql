-- Revert floq:upsert_invoice_balance_function from pg

BEGIN;

drop function upsert_invoice_balance(text, date, integer, numeric);

COMMIT;
