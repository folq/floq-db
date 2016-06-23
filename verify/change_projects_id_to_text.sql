-- Verify floq:change_projects_id_to_text on pg

BEGIN;

INSERT INTO projects
  (id, name, billable, customer)
  values ('someRandomTextAsID','rollbackName',false, 1);

INSERT INTO time_entry
  (employee, creator, minutes, project, date)
  values (1, 1, 30, 'someRandomTextAsID', '01-01-2016');

ROLLBACK;
