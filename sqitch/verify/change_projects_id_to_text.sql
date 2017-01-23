-- Verify floq:change_projects_id_to_text on pg

BEGIN;

  select id, name, billable, customer
    from projects
    where FALSE;

  select 1/count(*)
    from information_schema.columns
    where table_name = 'projects' and column_name = 'id' and data_type='text';

ROLLBACK;
