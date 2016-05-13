-- Deploy floq:time_tracking_functions to pg
-- requires: time_tracking_tables

BEGIN;

create or replace function entries_sums_for_employee(employee_id integer, start_date date default date_trunc('week', current_date), days integer default 7)
returns table (
    date date,
    sum integer)
as $$
    select date, sum(minutes)::integer from time_entry
    where employee = employee_id
      and date >= start_date
      and date < start_date + days
    group by date;
$$
language sql stable;

create or replace function projects_for_employee_for_date(employee_id integer, date date default current_date)
returns TABLE (
    id integer,
    project text,
    customer text,
    minutes integer)
as $$
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
$$
language sql immutable strict;

COMMIT;
