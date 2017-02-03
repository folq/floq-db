-- Revert floq:absence_table from pg

BEGIN;

INSERT INTO staffing (employee, date, project)
  ( SELECT employee_id as employee, date, reason as project
      FROM absence
  );

DROP TABLE absence CASCADE;

COMMIT;
