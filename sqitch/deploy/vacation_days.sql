-- Deploy floq:vacation_days to pg

BEGIN;

CREATE TABLE vacation_days (
    employee_id INTEGER NOT NULL REFERENCES employees(id),
    year INTEGER NOT NULL,
    days_earnt NUMERIC NOT NULL,
    comment TEXT,
    PRIMARY KEY (employee_id, year)
);


-- View returning one row per calendar year the employee has been employed
CREATE VIEW employee_years AS (
    SELECT id as employee, date_part('year',date_trunc('year', dd))::INTEGER AS year
    FROM employees, generate_series ( employees.date_of_employment::DATE , NOW()::DATE, '1 year'::interval) dd
);

-- View returning vacation days earnt per year the employee has been employed, defaulting to 25
CREATE VIEW vacation_days_earnt AS (
    SELECT employee, employee_years.year, coalesce(days_earnt, 25) AS days_earnt
    FROM employee_years 
    LEFT JOIN vacation_days on vacation_days.year = employee_years.year
);

-- View returning vacation days spent per year the employee has been employed, defaulting to 0
CREATE VIEW vacation_days_spent AS (
    SELECT employee_years.employee, employee_years.year, coalesce(days_spent, 0.0) AS days_spent
    FROM employee_years 
    LEFT JOIN (select employee, date_part('year', date) as year, sum(minutes)/60.0/7.5::float8 AS days_spent FROM time_entry WHERE project = 'FER1000' GROUP BY employee, year) vacation_days_spent
    ON (vacation_days_spent.year = employee_years.year AND vacation_days_spent.employee = employee_years.employee)
    
);

CREATE VIEW vacation_days_by_year AS (
	SELECT vacation_days_spent.employee, vacation_days_spent.year, days_earnt, days_spent 
	FROM vacation_days_spent, vacation_days_earnt 
	WHERE vacation_days_spent.employee = vacation_days_earnt.employee AND vacation_days_spent.year = vacation_days_earnt.year
);

COMMIT;
