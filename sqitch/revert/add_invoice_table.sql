-- Revert floq:add_invoice_table from pg

BEGIN;

DROP TABLE invoice;

COMMIT;
