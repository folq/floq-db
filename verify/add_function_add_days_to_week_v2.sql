-- Verify floq:add_function_add_days_to_week on pg

BEGIN;

INSERT INTO employees
  (id,first_name,last_name,title, phone, email,gender,birth_date)
  values (191919195,'Jacob','Aal','Federator', '91919191','some@email.com', 'male', '1972-01-01');

INSERT INTO customers
  (id, name)
  values (91828374,'I am not a customer!');

INSERT INTO projects
  (id, name, billable, customer)
  values ('someRandomTextAsID956','rollbackName','billable', 91828374);

select add_days_to_week(191919195, 'someRandomTextAsID956', 1, '2025-01-01');

ROLLBACK;
