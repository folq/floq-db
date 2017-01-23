-- Deploy floq:alter_table_invoice_balance_add_col_status to pg
-- requires: balance_tables

BEGIN;

create type invoice_status as enum ('not_done', 'not_ok', 'ok', 'sent');

alter table invoice_balance add column status invoice_status NOT NULL DEFAULT 'not_done';

COMMIT;
