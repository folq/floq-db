-- Sums all entries grouped by DATE and PROJECT 
CREATE OR REPLACE FUNCTION entries_sums_for_employee_with_project(employee_id int, from_date date, to_date date)
returns table (work_date date, employeeId int, project text, hours numeric) as
$$
begin
return query (
SELECT
  dates.date,
  time_entry.employee,
  time_entry.project,
  SUM(time_entry.minutes)/60.0 AS hours
FROM
  generate_series(from_date, to_date, '1 day'::interval) as dates 
  LEFT JOIN time_entry ON (dates.date = time_entry.date AND time_entry.employee = employee_id)
GROUP BY
  dates.date,
  time_entry.project,
  time_entry.employee
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
