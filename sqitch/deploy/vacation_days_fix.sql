-- Deploy floq:vacation_days_fix to pg

BEGIN;

-- Fix this view, adding the COALESCE on termination_date, before defaulting to NOW()
CREATE OR REPLACE VIEW employee_years AS (
    SELECT id as employee, date_part('year',date_trunc('year', dd))::INTEGER AS year
    FROM employees, generate_series ( employees.date_of_employment::DATE , COALESCE(employees.termination_date, NOW())::DATE, '1 year'::interval) dd
);

COMMIT;
