CREATE OR REPLACE FUNCTION public.lock_employee_hours(in_project text, in_start date, in_end date, in_commit date, in_creator integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  BEGIN
    INSERT INTO
        timelock (employee, creator, commit_date)
    SELECT DISTINCT
        te.employee, in_creator, in_commit
    FROM time_entry AS te
    WHERE te.project = in_project AND te.date >= in_start AND te.date <= in_end;
  END;
$function$
