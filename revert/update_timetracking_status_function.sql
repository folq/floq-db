-- Revert floq:update_timetracking_status_function from pg

BEGIN;

create or replace function time_tracking_status(start_date date, end_date date)
returns TABLE (
    name text,
    available_hours float8,
    billable_hours float8)
as $$
declare
    business_hours int;
begin
  business_hours := (select count(date)*7.5 from (
      select *
      from generate_series(start_date, end_date, '1 day'::interval) as date
      where extract(dow from date) between 1 and 5
        except
      select date from holidays
      ) as date
  );
  return query (
    select e.first_name || ' ' || e.last_name,
           business_hours - coalesce(sum(t.unavailable_hours)/60.0, 0.0)::float8,
           coalesce(sum(t.billable_hours)/60.0, 0.0)::float8
    from (
        select coalesce(uah.employee, bh.employee) as employee,
               uah.sum as unavailable_hours,
               bh.sum as billable_hours
        from (
            -- find sum of unavailable time (holidays, vacation days, sick leave, etc.) per employee
            select t.employee, sum(minutes)
            from time_entry t,
                 projects p
            where t.project = p.id
              and t.date between start_date and end_date
              and p.billable = 'unavailable'
            group by t.employee
        ) uah
        full outer join (
            -- find sum of billable hours worked per employee
            select t.employee, sum(minutes)
            from time_entry t,
                 projects p
            where t.project = p.id
              and t.date between start_date and end_date
              and p.billable = 'billable'
            group by t.employee
        ) bh
        on uah.employee = bh.employee) as t
    -- include all employees
    right join employees e on t.employee = e.id
    group by e.id
    order by name
  );
end
$$
language plpgsql immutable strict;

drop function business_hours(date, date, float8)

COMMIT;
