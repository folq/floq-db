-- Revert floq:alter_table_invoice_balance_extend_date_contraint from pg

BEGIN;

DROP INDEX unique_invoiceprojectdate;
CREATE UNIQUE INDEX unique_invoicedate
  ON invoice_balance
  USING btree
  (date);

COMMIT;
