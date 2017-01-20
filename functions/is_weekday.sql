CREATE OR REPLACE FUNCTION public.is_weekday(d date)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN NOT (    EXTRACT(dow FROM d) = 0
               OR EXTRACT(dow FROM d) = 6
             );
END
$function$
