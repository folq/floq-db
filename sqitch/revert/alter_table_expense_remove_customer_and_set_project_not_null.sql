-- Revert floq:alter_table_expense_remove_customer_and_set_project_not_null from pg

BEGIN;

ALTER TABLE expense
  ADD COLUMN customer integer,
  ADD CONSTRAINT expense_customer_fkey FOREIGN KEY (customer)
      REFERENCES public.customers (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ALTER COLUMN project DROP NOT NULL;

COMMIT;
