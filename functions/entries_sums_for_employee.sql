
-- Sums all entries grouped by DATE and PROJECT 
CREATE OR REPLACE FUNCTION public.entries_sums_for_employee_with_project(employee_id int, from_date date, to_date date)
returns table (work_date date, project text, hours numeric, employeeId int) as
$$
begin
return query (
SELECT 
    time_entry.date,
    time_entry.employee
    SUM(time_entry.minutes)/60.0 AS hours,
    time_entry.project,
FROM
    time_entry JOIN employees ON time_entry.employee = employees.id
WHERE
    date >= from_date 
    AND date <= to_date
    AND employees.id = employee_id
GROUP BY
	time_entry.date,
	time_entry.project,
	employee
);
end
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.entries_sums_for_employee(employee_id integer, start_date date DEFAULT date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone), days integer DEFAULT 7)
 RETURNS TABLE(date date, sum integer)
 LANGUAGE sql
 STABLE
AS $function$
    select date, sum(minutes)::integer from time_entry
    where employee = employee_id
      and date >= start_date
      and date < start_date + days
    group by date;
$function$
