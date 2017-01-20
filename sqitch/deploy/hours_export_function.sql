-- Deploy floq:hours_export_function to pg

BEGIN;

create function hours_per_employee(start_date date, end_date date)
returns table (
  name text,
  hours json
) as $$
begin
    if end_date - start_date > 366 then
        raise exception 'maximum time span allowed is 366 days';
    end if;

    return query (
        select e.first_name || ' ' || e.last_name,
        (
            select json_agg(json_build_object(i::date, t.sum))
                from generate_series(start_date, end_date, '1 day'::interval) i
                left join (
                    -- select (date, hours) pair for employee
                    select date, round(sum(minutes)/60.0, 1) as sum
                    from time_entry
                    where employee = e.id
                      and date >= start_date
                      and date <= end_date
                    group by date
                ) t
                on t.date = i::date
        )
        from employees e
    );
end;
$$ language 'plpgsql' stable;

COMMIT;
