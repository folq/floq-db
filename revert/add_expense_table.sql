-- Revert floq:add_expense_table from pg

BEGIN;

DROP TABLE expense;

COMMIT;
