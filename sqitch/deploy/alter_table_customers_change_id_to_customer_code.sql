-- Deploy floq:alter_table_customers_change_id_to_customer_code to pg

BEGIN;

ALTER TABLE projects
  DROP CONSTRAINT projects_customer_fkey,
  ALTER COLUMN customer TYPE text;

ALTER TABLE customers
  ALTER COLUMN id DROP DEFAULT,
  ALTER COLUMN id TYPE text;

ALTER TABLE projects
  ADD CONSTRAINT projects_customer_fkey FOREIGN KEY (customer)
      REFERENCES customers (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;

COMMIT;
