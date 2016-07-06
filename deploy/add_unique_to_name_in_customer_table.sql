-- Deploy floq:add_unique_to_name_in_customer_table to pg

BEGIN;

ALTER TABLE customers
  DROP CONSTRAINT IF EXISTS unique_customer_name,
  ADD CONSTRAINT unique_customer_name UNIQUE (name);
COMMIT;
