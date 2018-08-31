-- Deploy floq:vacation_days to pg

BEGIN;

CREATE TABLE vacation_days (
    employee_id INTEGER NOT NULL REFERENCES employees(id),
    year INTEGER NOT NULL,
    days_earnt NUMERIC NOT NULL,
    comment TEXT,
    PRIMARY KEY (employee_id, year)
);

COMMIT;
