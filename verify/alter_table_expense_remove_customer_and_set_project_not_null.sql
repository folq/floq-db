-- Verify floq:alter_table_expense_remove_customer_and_set_project_not_null on pg

BEGIN;

INSERT INTO customers
  (id, name)
  values (91118491,'a-bc-some-name-!');

INSERT INTO projects
  (id, name, billable, customer)
  values ('someRandomTzzzxtAsID9566','textHere?','billable', 91118491);

INSERT INTO expense
  (project, date, amount)
  values ('someRandomTzzzxtAsID9566','2016-01-01', 1);

ROLLBACK;
