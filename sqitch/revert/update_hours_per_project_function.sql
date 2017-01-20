-- Revert floq:update_hours_per_project_function from pg

BEGIN;

DROP FUNCTION hours_per_project(date,date);
CREATE OR REPLACE FUNCTION hours_per_project(in_start_date date, in_end_date date)
  RETURNS TABLE(project TEXT, hours FLOAT, start_date DATE, end_date DATE)
LANGUAGE plpgsql
STABLE
AS $function$
begin

  return query (
    select t.project, round(sum(minutes)/60.0, 1)::FLOAT as hours, in_start_date, in_end_date from time_entry t, projects p
    where t.date between in_start_date AND in_end_date
          and t.project = p.id
          and p.billable = 'billable'
    group by t.project
    order by t.project
  );

end;
$function$;

COMMIT;
