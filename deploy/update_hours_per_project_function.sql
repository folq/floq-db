-- Deploy floq:update_hours_per_project_function to pg
-- required: alter_invoice_table_money_to_numeric

BEGIN;

DROP FUNCTION hours_per_project(date,date);
CREATE OR REPLACE FUNCTION hours_per_project(in_start_date date, in_end_date date)
  RETURNS TABLE(project TEXT, time_entry_hours FLOAT, invoice_balance_hours FLOAT, invoice_balance_money FLOAT, write_off_hours FLOAT, expense_money FLOAT, subcontractor_money FLOAT, start_date DATE, end_date DATE)
LANGUAGE plpgsql
STABLE
AS $function$
begin
  return query (
    select
      p.id,
      coalesce(t.hours,0),
      coalesce(i.invoice_balance_hours,0),
      coalesce(i.invoice_balance_money,0),
      coalesce(i.write_off_hours,0),
      coalesce(i.expense_money,0),
      coalesce(i.subcontractor_money,0),
      in_start_date,
      in_end_date
    from
      projects p
      left join (
	select
		round(sum(i.minutes)/60.0, 1)::FLOAT as invoice_balance_hours,
		sum(i.amount)::FLOAT as invoice_balance_money,
		round(sum(w.minutes)/60.0, 1)::FLOAT as write_off_hours,
		sum(e.amount)::FLOAT as expense_money,
		sum(s.amount)::FLOAT as subcontractor_money,
		i.project
	from invoice_balance i
	left join write_off w on w.invoice_balance=i.id
	left join expense e on e.invoice_balance=i.id and e.type='other'
	left join expense s on s.invoice_balance=i.id and s.type='subcontractor'
	where i.date between in_start_date AND in_end_date
	group by i.project
      ) i on i.project = p.id
      left join (
	select round(sum(t.minutes)/60.0, 1)::FLOAT as hours, t.project as project
	from time_entry t
	where t.date between in_start_date AND in_end_date
	group by t.project
      ) t on t.project = p.id
    where
      p.billable = 'billable'
    order by p.id
  );
end;
$function$;

COMMIT;
