-- Deploy floq:paid_overtime_table to pg

BEGIN;

CREATE TABLE paid_overtime (
  id SERIAL PRIMARY KEY,
  employee INTEGER NOT NULL REFERENCES employees(id),
  date DATE NOT NULL,
  minutes INTEGER NOT NULL,
  comment TEXT NOT NULL
);

COMMIT;
