-- Deploy floq:absence_table to pg

BEGIN;

CREATE TABLE absence (
  employee_id integer NOT NULL REFERENCES employees(id),

  date date NOT NULL,
    CHECK(NOT is_holiday(date)),

  reason text NOT NULL REFERENCES projects(id),
    CHECK(is_absence_reason(reason)),

  PRIMARY KEY (employee_id, date)
);

INSERT INTO absence (employee_id, date, reason)
  ( SELECT employee, date, project as reason
      FROM staffing
     WHERE is_absence_reason(project) AND NOT is_holiday(date)
  );

DELETE FROM staffing WHERE is_absence_reason(project);

COMMIT;
