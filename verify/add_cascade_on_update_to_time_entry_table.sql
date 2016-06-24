-- Verify floq:add_cascade_on_update_to_time_entry_table on pg

BEGIN;

INSERT INTO projects
  (id, name, billable, customer)
  values ('oldId789','rollbackName',false, 1);

INSERT INTO time_entry
  (employee, creator, minutes, project, date)
  values (1, 1, 30, 'oldId789', '01-01-2016');

update projects set id='newId789' where id='oldId789';

ROLLBACK;
