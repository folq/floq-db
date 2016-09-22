-- Revert floq:add_read_only_function_worked_days_per_week from pg

BEGIN;

DROP FUNCTION IF EXISTS worked_days_per_week(date,integer);

CREATE OR REPLACE FUNCTION worked_days_per_week(
 IN in_week INTEGER,
 IN in_number_of_weeks INTEGER default 5,
 IN in_year INTEGER DEFAULT date_part('year', CURRENT_DATE)
)
RETURNS TABLE(
	employee integer,
  projects text[],
	week integer,
	days integer
) AS $$
BEGIN
 IF (in_week < 0 OR in_week > 53) then RAISE numeric_value_out_of_range USING MESSAGE = 'week-parameter has to be within: [0,53] but was ' || in_week; END IF;
 IF (in_number_of_weeks < 1) then RAISE numeric_value_out_of_range USING MESSAGE = 'number_of_weeks-parameter has to be greater than 0, but was ' || in_number_of_weeks; END IF;
return query(SELECT
        e.id as employee,
        array_agg(s.project) as projects,
        current_week as week,
        count(s.date)::integer as days
    FROM
        generate_series(in_week, in_week + in_number_of_weeks - 1) as current_week
    LEFT JOIN
        staffing s
            on s.date between week_to_date(in_year, current_week) AND (week_to_date(in_year, current_week) + 6)
    JOIN
        employees e
            on s.employee = e.id
    group by
        e.id,
        week
    order by
        e.id,
        week
);
END;
$$ LANGUAGE plpgsql;

COMMIT;
