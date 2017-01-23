CREATE OR REPLACE FUNCTION public.accumulated_hours_for_employee(employee_id integer, start_date date, end_date date)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
declare
	alltime_hours float8;
BEGIN
  alltime_hours := (select coalesce(sum(alltime_entries.minutes)/60.0,0.0)::float8 from (
    select *
      from time_entry
      where date between start_date and end_date and employee = employee_id
    ) as alltime_entries);

  RETURN alltime_hours;
END;
$function$
