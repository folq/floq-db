-- Verify floq:add_cascade_on_update_to_time_entry_table on pg

BEGIN;

INSERT INTO employees
  (id,first_name,last_name,title, phone, email,gender,birth_date)
  values (191915195,'Jacob','Aal','Federator', '91919191','some@email.com', 'male', '1972-01-01');

INSERT INTO customers
  (id, name)
  values (9959931,'customersName');

INSERT INTO projects
  (id, name, billable, customer)
  values ('projectsId','projectsName',false, 9959931);

INSERT INTO time_entry
  (employee, creator, minutes, project, date)
  values (191915195, 191915195, 30, 'projectsId', '01-01-2099');

update projects set id='newProjectsId' where id='projectsId';

select 1/count(*) from projects where id='newProjectsId';
select 1/count(*) from time_entry where project='newProjectsId';

ROLLBACK;
