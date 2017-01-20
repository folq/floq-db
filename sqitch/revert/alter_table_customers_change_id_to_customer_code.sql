-- Revert floq:alter_table_customers_change_id_to_customer_code from pg

BEGIN;

ALTER TABLE projects
  DROP CONSTRAINT projects_customer_fkey,
  ALTER COLUMN customer TYPE integer USING (customer::integer);

ALTER TABLE customers
  ALTER COLUMN id TYPE integer USING (id::integer),
  ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);

ALTER TABLE projects
  ADD CONSTRAINT projects_customer_fkey FOREIGN KEY (customer)
      REFERENCES customers (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMIT;
