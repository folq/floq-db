-- Verify floq:balance_tables on pg

BEGIN;

INSERT INTO customers
  (id, name)
  values ('someTEXThere17','I am not a customer!');

INSERT INTO projects
  (id, name, billable, customer)
  values ('someRandomTextzz4','rollbackNamez4','billable', 'someTEXThere17');

insert into invoice_balance
  (id, project, date)
  values ('inv_bal_rnd', 'someRandomTextzz4','2016-01-31');

insert into write_off
  (invoice_balance, minutes)
  values ('inv_bal_rnd', 600);

insert into expense
  (invoice_balance, type, amount)
  values ('inv_bal_rnd', 'other', 1000);

ROLLBACK;
