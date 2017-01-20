-- Revert floq:add_unique_to_name_in_customer_table from pg

BEGIN;

ALTER TABLE customers
  DROP CONSTRAINT IF EXISTS unique_customer_name;

COMMIT;
