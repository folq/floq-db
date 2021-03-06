CREATE OR REPLACE FUNCTION public.worked_days_per_week(in_start_of_week date, in_number_of_weeks integer DEFAULT 8)
 RETURNS TABLE(employee integer, projects text[], start_of_week date, days integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
 IF (in_number_of_weeks < 1) then RAISE numeric_value_out_of_range USING MESSAGE = 'number_of_weeks-parameter has to be greater than 0, but was ' || in_number_of_weeks; END IF;
return query(SELECT
        e.id as employee,
        array_agg(s.project) as projects,
        current_start_of_week::date as start_of_week,
        count(s.date)::integer as days
    FROM
        generate_series(in_start_of_week::date, (in_start_of_week + (7 * in_number_of_weeks - 1))::date, '7 days'::interval) as current_start_of_week
    LEFT JOIN
        staffing s
            on s.date between current_start_of_week::date AND (current_start_of_week::date + 6)::date
    JOIN
        employees e
            on s.employee = e.id
    group by
        e.id,
        start_of_week
    order by
        e.id,
        start_of_week
);
END;
$function$
