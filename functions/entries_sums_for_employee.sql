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
