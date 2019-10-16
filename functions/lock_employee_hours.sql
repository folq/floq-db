CREATE OR REPLACE FUNCTION public.lock_employee_hours(in_project text, in_start date, in_end date, in_commit date, in_creator integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  BEGIN
    INSERT INTO
        timelock_events (creator, employee, commit_date)
    SELECT DISTINCT
      in_creator, te.employee, in_commit
    FROM time_entry AS te
    WHERE te.project = in_project AND te.date >= in_start AND te.date <= in_end AND NOT EXISTS (
      SELECT * FROM timelock_view WHERE employee = te.employee AND commit_date = in_commit
    );
    REFRESH MATERIALIZED VIEW CONCURRENTLY timelock_view;
  END;
$function$
