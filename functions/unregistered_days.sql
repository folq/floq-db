CREATE OR REPLACE FUNCTION public.unregistered_days(start_date date, end_date date, in_employee integer)
 RETURNS integer
 LANGUAGE sql
 STABLE STRICT
AS $function$
  select count(unregistered_day)::integer
  from (
  select day::date
    from generate_series(start_date, end_date, '1 day'::interval) as day
    where extract(dow from day) between 1 and 5
  except
    select date from holidays
  except
    (select distinct te.date as day from time_entry te where te.date between start_date and end_date and te.employee=in_employee)
  ) as unregistered_day
$function$
