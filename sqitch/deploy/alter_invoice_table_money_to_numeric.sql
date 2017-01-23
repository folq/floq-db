-- Deploy floq:alter_invoice_table_money_to_numeric to pg
-- required: balance_tables

BEGIN;

ALTER TABLE invoice_balance
  ALTER COLUMN amount type numeric(10,2);

COMMIT;
