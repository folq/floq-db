-- Deploy floq:add_read_only_function_employee_worked_days_in_week to pg

BEGIN;

DROP FUNCTION IF EXISTS employee_worked_days_per_week(integer,date,integer);

CREATE OR REPLACE FUNCTION employee_worked_days_per_week(
 IN in_employee INTEGER,
 IN in_start_of_week DATE DEFAULT CURRENT_DATE + 1 - (EXTRACT(DOW FROM CURRENT_DATE))::integer,
 IN in_number_of_weeks INTEGER default 8
)
RETURNS TABLE(
	start_of_week date,
	days integer,
	projects text[]
) AS $$
BEGIN
 IF (in_number_of_weeks < 1) then RAISE numeric_value_out_of_range USING MESSAGE = 'number_of_weeks-parameter has to be greater than 0, but was ' || in_number_of_weeks; END IF;
return query(SELECT
        current_start_of_week::date as start_of_week,
        count(s.date)::integer as days,
        array_agg(s.project) as projects
    FROM
        generate_series(in_start_of_week::date, (in_start_of_week + (7 * in_number_of_weeks - 1))::date, '7 days'::interval) as current_start_of_week
    INNER JOIN
        staffing s
            on s.date between current_start_of_week::date AND (current_start_of_week::date + 6)::date
            and s.employee = in_employee
    group by
        start_of_week
    order by
        start_of_week
);
END;
$$ LANGUAGE plpgsql;

COMMIT;
