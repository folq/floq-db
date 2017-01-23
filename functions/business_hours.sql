CREATE OR REPLACE FUNCTION public.business_hours(start_date date, end_date date, hours_per_day double precision DEFAULT 7.5)
 RETURNS double precision
 LANGUAGE sql
 STABLE STRICT
AS $function$
  select count(date)*7.5::float8 from (
      select *
      from generate_series(start_date, end_date, '1 day'::interval) as date
      where extract(dow from date) between 1 and 5
        except
      select date from holidays
  ) as date;
$function$
