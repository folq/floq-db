CREATE OR REPLACE FUNCTION public.is_holiday(d date)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN EXISTS (SELECT * FROM holidays WHERE holidays.date = d);
END
$function$
