-- Verify floq:add_read_only_function_employee_worked_days_in_week on pg

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

INSERT INTO staffing
  (employee, project, date)
  values  (191919195, 'someRandomTextAsID956', '2029-8-8');

select 1/count(w.days) from employee_worked_days_per_week(191919195, '2029-08-08', 1) w;

ROLLBACK;
