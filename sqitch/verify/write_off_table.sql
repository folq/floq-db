-- Verify floq:write_off_table on pg

BEGIN;

INSERT INTO customers
  (id, name)
  values ('someTEXThere17','I am not a customer!');

INSERT INTO projects
  (id, name, billable, customer)
  values ('someRandomTextzz4','rollbackNamez4','billable', 'someTEXThere17');

insert into write_off
  (project, from_date, to_date, minutes)
  values ('someRandomTextzz4','2016-01-01','2016-02-01', 600);

ROLLBACK;
