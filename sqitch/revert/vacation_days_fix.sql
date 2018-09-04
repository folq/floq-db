-- Revert floq:vacation_days_fix from pg

BEGIN;

CREATE OR REPLACE VIEW employee_years AS (
    SELECT id as employee, date_part('year',date_trunc('year', dd))::INTEGER AS year
    FROM employees, generate_series ( employees.date_of_employment::DATE , NOW()::DATE, '1 year'::interval) dd
);

COMMIT;
