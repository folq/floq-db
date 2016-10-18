-- Revert floq:update_timetracking_status_function_alter_commit_date from pg

BEGIN;

drop function time_tracking_status(date, date);

create or replace function time_tracking_status(start_date date, end_date date)
returns TABLE (
    name text,
    available_hours float8,
    billable_hours float8,
    commit_date date)
as $$
begin
  return query (
    select e.first_name || ' ' || e.last_name,
           business_hours(greatest(e.date_of_employment, start_date), least(e.termination_date, end_date)) - coalesce(sum(t.unavailable_hours)/60.0, 0.0)::float8,
           coalesce(sum(t.billable_hours)/60.0, 0.0)::float8,
           cd.commit_date
    from employees e
    left join (
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
    on uah.employee = bh.employee) as t on t.employee = e.id
    left join (
      select distinct on(tl.employee) tl.commit_date, tl.employee
        from timelock tl order by tl.employee, tl.created desc
    ) cd on cd.employee=e.id
    where e.date_of_employment <= end_date
      and (e.termination_date is null or e.termination_date >= start_date)
    group by e.id, cd.commit_date
    order by name
  );
end
$$
language plpgsql immutable strict;

drop function unregistered_days(date,date,integer)

COMMIT;
