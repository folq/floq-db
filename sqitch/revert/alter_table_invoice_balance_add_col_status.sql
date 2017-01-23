-- Revert floq:alter_table_invoice_balance_add_col_status from pg

BEGIN;

alter table invoice_balance drop column status;

drop type invoice_status;

COMMIT;
