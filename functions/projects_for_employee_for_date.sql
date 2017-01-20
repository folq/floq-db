CREATE OR REPLACE FUNCTION public.projects_for_employee_for_date(employee_id integer, date date DEFAULT ('now'::text)::date)
 RETURNS TABLE(id text, project text, customer text, minutes integer)
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$
select project_row.id,
       project_row.name,
       customer_name,
       coalesce(sum(e.minutes), 0)::integer
from (
    select distinct t.project, p.name, p.id, c.name as customer_name
    from time_entry as t,
         projects as p,
         customers as c
    where date <= $2
      and date > $2 - '2 weeks'::interval
      and employee = $1
      and t.project = p.id
      and p.customer = c.id
    ) as project_row
left join time_entry e
    on e.date = $2
   and e.employee = $1
   and e.project = project_row.project
group by project_row.id,
         project_row.name,
         project_row.customer_name;
$function$
