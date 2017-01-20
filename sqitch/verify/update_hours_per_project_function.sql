-- Verify floq:update_hours_per_project_function on pg

BEGIN;

INSERT INTO employees
(id,first_name,last_name,title, phone, email,gender,birth_date)
values (17326532,'Jacob','Aal','Federator', '91919191','some@email.com', 'male', '1972-01-01');

INSERT INTO customers
(id, name)
values (91828374,'customersName');

INSERT INTO projects
(id, name, billable, customer)
values ('projectsId','projectsName','billable', 91828374);

INSERT INTO time_entry
(employee, creator, minutes, project, date)
values (17326532, 17326532, 30, 'projectsId', '2016-08-01');

INSERT INTO time_entry
(employee, creator, minutes, project, date)
values (17326532, 17326532, 60, 'projectsId', '2016-08-02');

insert into invoice_balance
  (id, project, date, amount, minutes)
  values ('invoiceBalanceId', 'projectsId','2016-08-31',1000,120);

insert into write_off
  (invoice_balance, minutes)
  values ('invoiceBalanceId', 600);

insert into expense
  (invoice_balance, type, amount)
  values ('invoiceBalanceId', 'other', 1000);

  insert into expense
    (invoice_balance, type, amount)
    values ('invoiceBalanceId', 'subcontractor', 1000);

select 1/count(h.time_entry_hours) from hours_per_project('2016-08-01', '2016-08-31') h;
select 1/count(h.invoice_balance_hours) from hours_per_project('2016-08-01', '2016-08-31') h;
select 1/count(h.invoice_balance_money) from hours_per_project('2016-08-01', '2016-08-31') h;
select 1/count(h.write_off_hours) from hours_per_project('2016-08-01', '2016-08-31') h;
select 1/count(h.expense_money) from hours_per_project('2016-08-01', '2016-08-31') h;
select 1/count(h.subcontractor_money) from hours_per_project('2016-08-01', '2016-08-31') h;

ROLLBACK;
