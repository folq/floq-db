CREATE OR REPLACE FUNCTION kpi_ot(in_from_date date, in_to_date date)
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
  sum(invoice_balance_money) / (sum(invoice_balance_minutes)/60.0)
FROM
  (
    SELECT * from month_dates(in_from_date, in_to_date)
  ) as x,	
  	hours_per_project(x.from_date, x.to_date) as hours_per_project
  	
GROUP BY x.from_date, x.to_date
);
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kpi_fg(in_from_date date, in_to_date date)
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
  100*(actual.sum_billable_hours / actual.sum_available_hours) AS payload
FROM
  (
  	SELECT * from month_dates(in_from_date, in_to_date)) x,
  		accumulated_billed_hours(x.from_date, '2018-07-01') actual
  );
END
$$ LANGUAGE plpgsql;




select  (
	(select sum(sum_business_hours) from sum_business_hours('2017-08-01', '2018-01-31')) - 
	(select sum(unavailable_hours) from unavailable_hours('2017-08-01', '2018-01-31')) 
	) 
available_hours;





CREATE OR REPLACE FUNCTION month_dates(in_from_date date, in_to_date date)
RETURNS TABLE ( to_date DATE, from_date DATE) AS
$$
BEGIN
  RETURN QUERY select date_trunc('MONTH', monat)::DATE, date_trunc('MONTH', monat - interval '6' month)::DATE from 
    (select * from generate_series(date_trunc('MONTH', in_from_date), date_trunc('MONTH', in_to_date),'1 month') as monat) as mt order by 1;
    END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION month_dates(in_from_date date, in_to_date date, in_interval interval)
RETURNS TABLE ( to_date DATE, from_date DATE) AS
$$
BEGIN
  RETURN QUERY select date_trunc('DAY', monat - interval '1' day)::DATE, date_trunc('MONTH', monat - in_interval)::DATE from 
    (select * from generate_series(date_trunc('MONTH', in_from_date), date_trunc('MONTH', in_to_date),'1 month') as monat) as mt order by 1;
    END
$$ LANGUAGE plpgsql;


DROP FUNCTION kpi_fg(date,date);

CREATE OR REPLACE FUNCTION kpi_fg(in_from_date date, in_to_date date)
RETURNS TABLE (
  from_date date,
  to_date date,
  fg numeric,
  billable_hours numeric,
  available_hours numeric,
  from2_date date,
  to2_date date
) AS
$$
BEGIN
  RETURN QUERY (

SELECT
  x.from_date,
  x.to_date,                                      
  100*(actual.sum_billable_hours / actual.sum_available_hours) AS fg,
  actual.sum_billable_hours,
  actual.sum_available_hours,
  in_from_date date,
  in_to_date date
FROM
  (
    SELECT * from month_dates(in_from_date, in_to_date, interval '6' month)) x,
      accumulated_billed_hours(x.from_date, x.to_date) actual
  );
END
$$ LANGUAGE plpgsql;


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
  	select business_hours from 
		(
			select employees.id as id, employees.first_name, employees.date_of_employment, employees.termination_date from employees,
			time_entry
			where time_entry.employee = employees.id
			and time_entry.date <= in_to_date and time_entry.date >= in_from_date
			group by employees.id, employees.date_of_employment, employees.termination_date
		) as e,
		business_hours(greatest(in_from_date, e.date_of_employment),least(e.termination_date, in_to_date))
  ) tt  
 );
END
$$ LANGUAGE plpgsql;


--
--CREATE OR REPLACE FUNCTION kpi_ot(in_from_date date, in_to_date date)
--RETURNS TABLE (
--  from_date date,
--  to_date date,
--  imoney double precision,
--  payload double precision
--) AS
--$$
--BEGIN
--  RETURN QUERY (
--SELECT
--  x.from_date,
--  x.to_date,
--  sum(invoice_balance_money), 
--  ot                   
--FROM
--  (
--    SELECT * from month_dates(in_from_date, in_to_date, interval '1' month)
--  ) as x, 
--    hours_per_project(x.from_date, x.to_date) as hours_per_project,
--    (sum(invoice_balance_money) - sum(subcontractor_money) - sum(expense_money)) / ((sum(invoice_balance_minutes))/60.0) as ot
--    
--GROUP BY x.from_date, x.to_date
--);
--END
--$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION accumulated_billed_hours2(from_date date, to_date date)
RETURNS TABLE (sum_available_hours double precision, sum_billable_hours numeric) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
         sum_business_hours - unavailable_hours :: double precision AS sum_available_hours,
         SUM(minutes/60.0)  :: numeric AS sum_billable_hours
       FROM 
		   	sum_business_hours('2017-08-01', '2018-01-31'), 
			unavailable_hours('2017-08-01', '2018-01-31'),
			time_entry join projects on projects.id = time_entry.project and projects.billable = 'billable' and date <= '2018-01-31' and date >= '2017-08-01'	
      group by (sum_business_hours, unavailable_hours)) LIMIT 1;
END
$$ LANGUAGE plpgsql;



select * from kpi_fg('2017-07-01', '2018-08-01');
--select * from kpi_ot('2018-07-01', '2018-07-01');
--select * from month_dates('2017-07-01', '2018-07-01');
--
--select * from accumulated_billed_hours('2017-07-01', '2018-02-01')