-- Deploy floq:alter_table_invoice_balance_extend_date_contraint to pg
-- required: balance_tables

BEGIN;

DROP INDEX unique_invoicedate;
CREATE UNIQUE INDEX unique_invoiceprojectdate
  ON invoice_balance
  USING btree
  (project, date);

COMMIT;
