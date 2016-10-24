-- Verify floq:alter_table_staffing_add_cascade_on_update on pg

BEGIN;

SELECT 1/count(*)
  FROM   pg_constraint
  WHERE  conname = 'staffing_project_fkey'
  AND    confupdtype = 'c';

 SELECT 1/count(*)
   FROM   pg_constraint
   WHERE  conname = 'staffing_employee_fkey'
   AND    confupdtype = 'c';

ROLLBACK;
