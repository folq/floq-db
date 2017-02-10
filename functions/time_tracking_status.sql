CREATE OR REPLACE FUNCTION public.time_tracking_status(start_date date, end_date date)
 RETURNS TABLE(name text, email text, available_hours double precision, billable_hours double precision, non_billable_hours double precision, unavailable_hours double precision, unregistered_days integer, last_date date, last_created date)
 LANGUAGE plpgsql
 STABLE STRICT
AS $function$
begin
  return query (
    select e.first_name || ' ' || e.last_name,
           e.email,
           business_hours(greatest(e.date_of_employment, start_date), least(e.termination_date, end_date)) - coalesce(sum(t.unavailable_hours)/60.0, 0.0)::float8,
           coalesce(sum(t.billable_hours)/60.0, 0.0)::float8,
           coalesce(sum(t.non_billable_hours)/60.0, 0.0)::float8,
           coalesce(sum(t.unavailable_hours)/60.0, 0.0)::float8,
           (select * from unregistered_days(start_date,end_date,e.id) u),
           ld.date,
           lc.created::date
    from employees e
    --(select unregistered_days from unregistered_days(start_date,end_date,e.id)) as unregistered_days
    left join (
       select coalesce(uah.employee, bh.employee,nbh.employee) as employee,
               uah.sum as unavailable_hours,
               bh.sum as billable_hours,
               nbh.sum as non_billable_hours
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
        on uah.employee = bh.employee
	full outer join (
            -- find sum of billable hours worked per employee
            select t.employee, sum(minutes)
            from time_entry t,
                 projects p
            where t.project = p.id
              and t.date between start_date and end_date
              and p.billable = 'nonbillable'
            group by t.employee
        ) nbh
        on uah.employee = nbh.employee) as t on t.employee = e.id
    -- find last time_entry date for employees
    left join (
      select distinct on(te.employee) te.employee, te.date
        from time_entry te order by te.employee, te.date desc
    ) ld on ld.employee=e.id
    -- find last time_entry created for employees
    left join (
      select distinct on(te.employee) te.employee, te.created
        from time_entry te order by te.employee, te.created desc
    ) lc on lc.employee=e.id
    where e.date_of_employment <= end_date
      and (e.termination_date is null or e.termination_date >= start_date)
    group by e.id, ld.date, lc.created
    order by e.first_name, e.last_name
  );
end
$function$