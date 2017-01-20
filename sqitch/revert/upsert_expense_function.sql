-- Revert floq:upsert_expense_function from pg

BEGIN;

drop function upsert_expense(text, date, text, numeric);

COMMIT;
