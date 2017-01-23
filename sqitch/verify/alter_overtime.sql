-- Verify floq:alter_overtime on pg

BEGIN;

select registered_date, paid_date from paid_overtime;

ROLLBACK;
