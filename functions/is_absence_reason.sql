CREATE OR REPLACE FUNCTION public.is_absence_reason(reason text)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN (    reason = 'FER1000'
           OR reason = 'SYK1001'
           OR reason = 'SYK1002'
           OR reason = 'PER1000'
           OR reason = 'PER1001'
         );
END
$function$
