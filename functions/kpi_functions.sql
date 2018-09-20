CREATE OR REPLACE FUNCTION kpi_fg(in_start_date date, in_end_date date)
RETURNS TABLE (
  from_date date,
  to_date date,
  fg double precision
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
  x.from_date,
  x.to_date,                                      
  100*(actual.sum_billable_hours / actual.sum_available_hours) AS fg
FROM
  (
    SELECT * from month_dates(in_start_date, in_end_date, interval '6' month)
  ) x,
   accumulated_billed_hours2(x.from_date, x.to_date) actual
  );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION kpi_product_development(in_start_date date, in_end_date date)
RETURNS TABLE (
 from_date date,
 to_date date,
 payload numeric
) AS
$$
BEGIN
 RETURN QUERY (
SELECT
 x.from_date,
 x.to_date,
 hours
FROM
 (
   SELECT * from month_dates(in_start_date, in_end_date, interval '6' month)
 ) AS x, 
   product_development_hours(x.from_date, x.to_date) AS hours   
GROUP BY x.from_date, x.to_date, hours.hours
);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION kpi_sick(in_from_date date, in_to_date date)
RETURNS TABLE (
 from_date date,
 to_date date,
 payload double precision
) AS
$$
BEGIN
 RETURN QUERY (
SELECT
 x.from_date,
 x.to_date,
 sick_hours / sum_business_hours
FROM
 (
   SELECT * from month_dates(in_from_date, in_to_date, interval '6' month)
 ) AS x, 
 sum_business_hours(x.from_date, x.to_date),
 sick_hours(x.from_date, x.to_date)
GROUP BY x.from_date, x.to_date, sum_business_hours, sick_hours
);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION kpi_ul(in_from_date date, in_to_date date)
RETURNS TABLE (
 from_date date,
 to_date date,
 payload double precision
) AS
$$
BEGIN
 RETURN QUERY (
SELECT
 x.from_date,
 x.to_date,
 sum(subcontractor_money) / sum(invoice_balance_money)
FROM
 (
   SELECT * from month_dates(in_from_date, in_to_date, interval '6' month)
 ) AS x, 
   hours_per_project(x.from_date, x.to_date) AS hours_per_project   
GROUP BY x.from_date, x.to_date
);
END
$$ LANGUAGE plpgsql;





-- HELPERS
CREATE OR REPLACE FUNCTION sum_business_hours(in_from_date date, in_to_date date)
RETURNS TABLE (
	sum_business_hours double precision
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
	sum(tt.business_hours)
FROM
  (
  	SELECT 
      business_hours 
    FROM 
		(
			SELECT 
        employees.id AS id,
        employees.first_name,
        employees.date_of_employment,
        employees.termination_date
      FROM
        employees
		) AS e,
		business_hours(greatest(in_from_date, e.date_of_employment),least(e.termination_date, in_to_date))
  ) tt  
 );
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accumulated_staffing_hours2(from_date date, to_date date)
RETURNS TABLE (available_hours double precision, billable_hours numeric) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
      sum_business_hours - unavailable_hours :: double precision AS sum_available_hours,
      (7.5 * count(*)):: numeric AS billable_hours
    FROM 
      sum_business_hours(from_date, to_date), 
      unavailable_staffing_hours(from_date, to_date),
      staffing
    JOIN projects ON
      projects.id = staffing.project AND
      projects.billable = 'billable' AND
      staffing.date <= to_date AND
      staffing.date >= from_date
    GROUP BY (sum_business_hours, unavailable_hours) LIMIT 1);
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accumulated_billed_hours2(from_date date, to_date date)
RETURNS TABLE (sum_available_hours double precision, sum_billable_hours numeric) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
         sum_business_hours - unavailable_hours :: double precision AS sum_available_hours,
         SUM(minutes/60.0)  :: numeric AS sum_billable_hours
    FROM 
     sum_business_hours(from_date, to_date), 
     unavailable_time_entry_hours(from_date, to_date),
     time_entry
    JOIN projects ON
      projects.id = time_entry.project AND
      projects.billable = 'billable' AND
      time_entry.date <= to_date and time_entry.date >= from_date 
    GROUP BY (sum_business_hours, unavailable_hours)) LIMIT 1;
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION unavailable_time_entry_hours(in_from_date date, in_to_date date)
RETURNS TABLE (
	unavailable_hours numeric
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
	tt.unavailable
FROM
  (
	select sum(minutes/60.0) AS unavailable from projects join time_entry on time_entry.project = projects.id where projects.billable='unavailable'	and time_entry.date >= in_from_date and time_entry.date <= in_to_date 
  ) tt  
 );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION month_dates(in_from_date date, in_to_date date, in_interval interval)
RETURNS TABLE ( to_date DATE, from_date DATE) AS
$$
BEGIN
  RETURN QUERY select date_trunc('DAY', monat - interval '1' day)::DATE, date_trunc('MONTH', monat - in_interval)::DATE from 
    (select * from generate_series(date_trunc('MONTH', in_from_date), date_trunc('MONTH', in_to_date),'1 month') AS monat) AS mt order by 1;
    END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION unavailable_staffing_hours(start_date date, end_date date)
RETURNS TABLE (
  unavailable_hours numeric
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
  tt.unavailable
FROM
  (
    SELECT
      7.5 * count(*) AS unavailable
    FROM
      staffing 
    JOIN projects ON
      staffing.project = projects.id
    WHERE 
      billable='unavailable' AND
      staffing.date <= end_date AND
      staffing.date >= start_date
  ) tt  
 );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sick_hours(start_date date, end_date date)
RETURNS TABLE (
sick_hours numeric
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
  tt.sick
FROM
  (
    SELECT
      sum(minutes)/60.0 AS sick
    FROM
      time_entry
    WHERE
      (project = 'SYK1000' OR project = 'SYK1001' OR project = 'SYK1002') AND
      (time_entry.date >= start_date AND time_entry.date <= end_date)
  ) tt  
 );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION product_development_hours(from_date date, to_date date)
RETURNS TABLE (
hours numeric
) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
      sum(minutes)/60.0 AS hours 
    FROM
      time_entry
    WHERE
      (project = 'INT1000' OR project = 'INT1004' OR project = 'INT1003') AND
      (time_entry.date >= from_date AND time_entry.date <= to_date)
 );
END
$$ LANGUAGE plpgsql;

-- Professional Development KPI

CREATE OR REPLACE FUNCTION public.total_hours_on_project_in_period(start_date date, end_date date, project_code text)
RETURNS TABLE(project_hours double precision)
LANGUAGE plpgsql
STABLE STRICT
AS $function$
begin
 return query (
   SELECT
    sum(minutes)/60::double precision AS project_hours
   FROM 
    time_entry
   WHERE
    time_entry.project = project_code AND
    time_entry.date BETWEEN start_date AND end_date
 );
end
$function$;


CREATE OR REPLACE FUNCTION public.kpi_prodev(start_date date, end_date date)
  RETURNS TABLE(from_date date, to_date date, percent double precision, project_hours double precision, available_hours double precision)
  LANGUAGE plpgsql
AS $function$
begin
  return query (
    SELECT
      d.from_date,
      d.to_date,
      ((f.project_hours / abh.sum_available_hours)*100)::double precision AS percent,
      f.project_hours,
      abh.sum_available_hours
    FROM
      (SELECT * from month_dates('2017-07-01', '2018-07-01', interval '6' month)) d,
      accumulated_billed_hours2(d.from_date, d.to_date) abh,
      total_hours_on_project_in_period(d.from_date, d.to_date, 'FAG1000') f
  );
end
$function$;

-- FG Deviation

CREATE OR REPLACE FUNCTION planned_billable_hours_in_period(start_date date, end_date date)
  RETURNS TABLE(date date, hours double precision)
AS $function$
begin
  return query (
    SELECT
      start_date::date,
      (SUM(spw.days) * 7.5)::double precision AS hours
    FROM staffing_per_week AS spw, projects AS p
    WHERE spw.project_id = p.id and p.billable = 'billable' 
    and to_date('' || spw.year || '-' || spw.week || '-1', 'IYYY-IW-ID') >= start_date
    and to_date('' || spw.year || '-' || spw.week || '-5', 'IYYY-IW-ID') <= end_date
  );
end
$function$;


CREATE OR REPLACE FUNCTION public.fgdev(start_date date, end_date date)
  RETURNS TABLE(org_date date, adj_date date, predicted_fg double precision, achieved_fg double precision, deviation_percent double precision)
AS $function$
begin
  return query (
    SELECT
      d.org_date::date AS org_date,
      d.adj_date::date AS adj_date,
      (pbh.hours/ash.available_hours)*100::double precision AS predicted_fg,
      (abh.sum_billable_hours/abh.sum_available_hours)*100::double precision AS achieved_fg,
      ((abh.sum_billable_hours/abh.sum_available_hours)/(pbh.hours/ash.available_hours))*100-100 AS deviation_percent
    FROM
      (
        SELECT
          dd AS org_date,
          (dd - ((SELECT CASE WHEN wd = 6 THEN 0 ELSE wd END FROM date_part('dow', dd) AS wd) || ' day')::INTERVAL) AS adj_date
        FROM 
          generate_series(start_date::timestamp, end_date::timestamp, '1 month') AS dd
      ) d,
      planned_billable_hours_in_period((d.adj_date::date - interval '12 week')::DATE, d.adj_date::date) pbh,
      accumulated_staffing_hours2((d.adj_date::date - interval '12 week')::DATE, d.adj_date::date) ash,
      accumulated_billed_hours2((d.adj_date::date - interval '12 week')::DATE, d.adj_date::date) abh
  );
end
$function$;

-- Visibility - forecasted FG (based of 12 next weeks)

CREATE OR REPLACE FUNCTION public.kpi_visibility(start_date date, end_date date)
  RETURNS TABLE(org_date date, fwd_adj_date date, to_date date, planned_billable_hours double precision, available_hours double precision, percent double precision)
  LANGUAGE plpgsql
AS $function$
begin
  return query (
    SELECT
      d.org_date::DATE,
      d.fwd_adj_date::DATE,
      (d.fwd_adj_date + interval '12 weeks')::DATE,
      ash.billable_hours::double precision,
      ash.available_hours::double precision,    
      (ash.billable_hours/ash.available_hours)*100::double precision as percentage_billable
    FROM
    (
      SELECT
        date_i as org_date,
        (date_i + ((7 - date_part('dow', date_i)) || ' day')::INTERVAL) as fwd_adj_date 
      FROM
        generate_series(date_trunc('MONTH', start_date::timestamp), date_trunc('MONTH', end_date::timestamp), '1 month') as date_i
    ) d,
    accumulated_staffing_hours(d.fwd_adj_date::DATE, (d.fwd_adj_date + interval '12 weeks')::DATE) ash
  );
end
$function$;

-- Accumulated reconciliation for whole company 
create or replace function accumulated_reconciliation(from_date date, to_date date)
returns table (write_off bigint , hours bigint, amount numeric, amount_net numeric, count bigint, subcontractor_hours bigint, subcontractor_expense numeric, other_expense numeric) as
$$
begin
return query (select 
    SUM(write_off.minutes)/60 as write_off,
    SUM(invoice_balance.minutes)/60 as hours,
    SUM(invoice_balance.amount) as total_amount,
    SUM(invoice_balance.amount) - (SUM(coalesce(invoice_expense.subcontractor_expense, 0)) + SUM(coalesce(invoice_expense.other_expense, 0))) as net_amount,
    COUNT(*) as count,
    SUM(CASE WHEN not invoice_expense.sum_expense ISNULL then invoice_balance.minutes else 0 end)/60 as subcontractor_hours,
    SUM(coalesce(invoice_expense.subcontractor_expense, 0)) as subcontractor_expense,
    SUM(coalesce(invoice_expense.other_expense, 0)) as other_expense
from 
    invoice_balance
    LEFT JOIN
        ( 
            SELECT 
                SUM(expense.amount) as sum_expense, 
                SUM(CASE WHEN type = 'subcontractor' then expense.amount else 0 end) as subcontractor_expense,
                SUM(CASE WHEN type = 'other' then expense.amount else 0 end) as other_expense,
                invoice_balance
            FROM expense
            WHERE NOT type ISNULL
            GROUP BY expense.invoice_balance
        ) AS invoice_expense ON invoice_balance.id = invoice_expense.invoice_balance
    LEFT JOIN write_off on write_off.invoice_balance = invoice_balance.id
where
    invoice_balance.date <= to_date and invoice_balance.date >= from_date
);
end
$$ LANGUAGE plpgsql;
-- Rolling "oppnådd timepris" over 6 months at a time
create or replace function ot_rolling(from_date date, to_date date)
returns table (write_off bigint , invoice_hours bigint, amount_gross numeric, amount_net numeric, subcontractor_hours bigint, subcontractor_expense numeric, from_d date, to_d date, billable_hours numeric, ot numeric) as
$$
begin
return query (select 
    ar.write_off,
    ar.hours as invoice_hours,
    ar.amount as amount_gross,
    ar.amount_net,
    ar.subcontractor_hours,
    ar.subcontractor_expense,
    month_dates.from_date as from_d,
    month_dates.to_date as to_d,
    x.sum_billable_hours as billable_hours,
    (ar.amount - (ar.subcontractor_expense+ar.other_expense)) / x.sum_billable_hours as ot
from
    (SELECT * FROM month_dates(from_date, to_date, interval '6' month)) month_dates,
    accumulated_reconciliation(month_dates.from_date, month_dates.to_date) as ar,
    accumulated_billed_hours2(month_dates.from_date, month_dates.to_date) as x
);
end
$$ LANGUAGE plpgsql;

-- Forcasted Available Hours (FG Deviation / Forcasted FG)

CREATE OR REPLACE FUNCTION unavilable_staffing_dates_in_period(from_date date, to_date date)
  RETURNS TABLE (employee_id integer, work_day date) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
    e.id as employee_id,
    s.date as staffed_id
  FROM
    employees AS e,
    staffing AS s,
    projects AS p
  WHERE
    e.id = s.employee AND
    s.project = p.id AND
    p.billable = 'unavailable' AND
    s.date BETWEEN greatest(from_date, e.date_of_employment) AND least(e.termination_date, to_date)
  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION all_employee_work_dates_in_period(from_date date, to_date date)
  RETURNS TABLE (employee_id int, work_date date) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
      e.id,
      s::DATE
  FROM
    employees AS e,
    generate_series(greatest(from_date, e.date_of_employment),least(e.termination_date, to_date), '1 day' :: interval) as s
  WHERE
    is_weekday(s::DATE) AND NOT is_holiday(s::DATE)
  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION all_absence_dates_in_period(from_date date, to_date date)
  RETURNS TABLE (employee_id int, absence_date date) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
    e.id as employee_id,
    a.date as absence_date
  FROM
    employees as e,
    absence as a,
    absence_reasons as ar
  WHERE
    e.id = a.employee_id AND
    a.reason = ar.id AND
    ar.billable = 'unavailable' AND
    a.date BETWEEN greatest(from_date, e.date_of_employment) AND least(e.termination_date, to_date)
  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION forcasted_available_hours(start_date date, end_date date)
  RETURNS TABLE (all_hours double precision, unavil_staffing_hours double precision, unavail_absence_hours double precision, available_hours double precision) AS
$$
BEGIN
  RETURN QUERY (
  SELECT
    ewd.hours::double precision as all_hours,
    usd.hours::double precision as unavil_staffing_hours,
    abs.hours::double precision as unavail_absence_hours,
    (ewd.hours - usd.hours - abs.hours)::double precision as available_hours
  FROM
    (SELECT COUNT(work_date) * 7.5 as hours FROM all_employee_work_dates_in_period(start_date, end_date)) AS ewd,
    (SELECT COUNT(work_day) * 7.5 as hours FROM unavilable_staffing_dates_in_period(start_date, end_date)) AS usd,
    (SELECT COUNT(absence_date) * 7.5 as hours FROM all_absence_dates_in_period(start_date, end_date)) AS abs
  );
END
$$ LANGUAGE plpgsql;


