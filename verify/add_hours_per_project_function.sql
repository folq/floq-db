-- Verify floq:add_hours_per_project_function on pg

BEGIN;

INSERT INTO employees
(id,first_name,last_name,title, phone, email,gender,birth_date)
values (191919195,'Jacob','Aal','Federator', '91919191','some@email.com', 'male', '1972-01-01');

INSERT INTO customers
(id, name)
values (91828374,'customersName');

INSERT INTO projects
(id, name, billable, customer)
values ('projectsId','projectsName','billable', 91828374);

INSERT INTO time_entry
(employee, creator, minutes, project, date)
values (191919195, 191919195, 30, 'projectsId', '2016-08-01');

INSERT INTO time_entry
(employee, creator, minutes, project, date)
values (191919195, 191919195, 60, 'projectsId', '2016-08-02');

select 1/count(h.hours) from hours_per_project('2016-08-01', '2016-08-31') h;

ROLLBACK;
