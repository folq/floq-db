-- Revert floq:alter_invoice_table_money_to_numeric from pg

BEGIN;

ALTER TABLE invoice_balance
  ALTER COLUMN amount type money;

COMMIT;
