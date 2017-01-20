-- Verify floq:alter_table_invoice_balance_add_col_status on pg

BEGIN;

select 1/count(*) from pg_type where typname = 'invoice_status';

select id, project, date, amount, minutes, created, invoicenumber, status from invoice_balance;

ROLLBACK;
