-- Revert floq:upsert_invoice_status_function from pg

BEGIN;

drop function upsert_invoice_status(text, date, text);

COMMIT;
