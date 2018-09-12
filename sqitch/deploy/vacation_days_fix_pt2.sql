-- Deploy floq:vacation_days_fix_pt2 to pg

BEGIN;

-- Fix this view, using date_trunc('year') on now(), to include everyone still employed
CREATE OR REPLACE VIEW employee_years AS (
    SELECT id as employee, date_part('year',date_trunc('year', dd))::INTEGER AS year
    FROM employees, generate_series ( date_trunc('year',employees.date_of_employment)::DATE, COALESCE(employees.termination_date, NOW())::DATE, '1 year'::interval) dd
);

COMMIT;
