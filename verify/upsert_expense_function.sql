-- Verify floq:upsert_expense_function on pg

BEGIN;

SELECT has_function_privilege('upsert_expense(text,date,text,numeric)', 'execute');

ROLLBACK;
