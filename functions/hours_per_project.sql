CREATE OR REPLACE FUNCTION public.hours_per_project(in_start_date date, in_end_date date)
 RETURNS TABLE(project text, status text, time_entry_minutes integer, invoice_balance_minutes integer, invoice_balance_money double precision, write_off_minutes integer, expense_money double precision, subcontractor_money double precision, start_date date, end_date date)
 LANGUAGE plpgsql
 STABLE
AS $function$
begin
  return query (
    select
      p.id,
      i.status,
      coalesce(t.time_entry_minutes,0),
      coalesce(i.invoice_balance_minutes,0),
      coalesce(i.invoice_balance_money,0),
      coalesce(i.write_off_minutes,0),
      coalesce(i.expense_money,0),
      coalesce(i.subcontractor_money,0),
      in_start_date,
      in_end_date
    from
      projects p
      left join (
	select
		i.minutes::INTEGER as invoice_balance_minutes,
		i.amount::FLOAT as invoice_balance_money,
		sum(w.minutes)::INTEGER as write_off_minutes,
		sum(e.amount)::FLOAT as expense_money,
		sum(s.amount)::FLOAT as subcontractor_money,
		i.status::TEXT as status,
		i.project
	from invoice_balance i
	left join write_off w on w.invoice_balance=i.id
	left join expense e on e.invoice_balance=i.id and e.type='other'
	left join expense s on s.invoice_balance=i.id and s.type='subcontractor'
	where i.date between in_start_date AND in_end_date
	group by i.project, i.status, i.minutes, i.amount
      ) i on i.project = p.id
      left join (
	select sum(t.minutes)::INTEGER as time_entry_minutes, t.project as project
	from time_entry t
	where t.date between in_start_date AND in_end_date
	group by t.project
      ) t on t.project = p.id
    where
      p.billable = 'billable'
    order by p.id
  );
end;
$function$
