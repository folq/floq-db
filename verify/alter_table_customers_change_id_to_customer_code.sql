-- Verify floq:alter_table_customers_change_id_to_customer_code on pg

BEGIN;

INSERT INTO customers
  (id, name)
  values ('CAN_THE_TEXT_CONTAIN:æøå','someRandomNamezz33');

INSERT INTO projects
  (id, name, billable, customer)
  values ('SOMERANDOMUNUSEDWORDS1zz','SOMERANDOMUNUSEDWORDS1zzz','billable', 'CAN_THE_TEXT_CONTAIN:æøå');

ROLLBACK;
