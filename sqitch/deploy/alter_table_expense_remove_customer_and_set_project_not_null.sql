-- Deploy floq:alter_table_expense_remove_customer_and_set_project_not_null to pg

BEGIN;

ALTER TABLE expense
  DROP CONSTRAINT expense_customer_fkey,
  DROP COLUMN IF EXISTS customer,
  ALTER COLUMN project SET NOT NULL;

COMMIT;
