BEGIN;


CREATE OR REPLACE FUNCTION accumulated_staffing_hours(from_date date, to_date date)
RETURNS TABLE (available_hours NUMERIC, billable_hours NUMERIC, nonbillable_hours NUMERIC, unavailable_hours NUMERIC) AS
$$
BEGIN
  RETURN QUERY (
SELECT
    (select count(work_day) * 7.5 as avail_hours FROM possible_work_dates_per_employee(from_date, to_date)) AS available_hours,
    sum(case when staff.billable = 'billable' :: TIME_STATUS then 1 else 0 end) * 7.5 AS billable_hours,
    sum(case when staff.billable = 'nonbillable' :: TIME_STATUS then 1 else 0 end) * 7.5 AS nonbillable_hours,
    sum(case when staff.billable = 'unavailable' :: TIME_STATUS then 1 else 0 end) * 7.5 AS unavailable_hours
  FROM (select * FROM staffing
    JOIN projects ON (staffing.project = projects.id)
    WHERE staffing.date BETWEEN from_date AND to_date) as staff

  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION possible_work_dates_per_employee(from_date date, to_date date)
RETURNS TABLE (employee_id integer, work_day date) AS
$$
BEGIN
  RETURN QUERY (
    select
      x.emp_id,
      x.work_day
    FROM
      (SELECT
         e.id                    AS emp_id,
         e.first_name,
         e.last_name,
         generate_series :: DATE AS work_day
       FROM employees e
         CROSS JOIN
           generate_series(from_date, to_date, '1 day' :: INTERVAL)
      ) AS x
    WHERE
      is_possible_work_day(x.emp_id, x.work_day)
  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION is_possible_work_day(in_employee_id NUMERIC, in_date DATE)
  RETURNS BOOLEAN AS
$$
BEGIN
  RETURN (
    is_weekday(in_date)
    AND NOT is_holiday(in_date)
    AND NOT exists(SELECT *
                   FROM employees e
                   WHERE e.id = in_employee_id AND e.termination_date < in_date)
    AND exists(SELECT *
               FROM employees e
               WHERE e.id = in_employee_id AND e.date_of_employment <= in_date)
    AND (
      NOT exists(SELECT *
                 FROM staffing s
                 WHERE s.employee = in_employee_id AND s.date = in_date)
      OR exists(SELECT *
                FROM staffing s
                  JOIN projects p ON s.project = p.id
                WHERE s.employee = in_employee_id AND s.date = in_date AND p.billable != 'unavailable' :: TIME_STATUS)
    )
    AND NOT exists(SELECT *
                   FROM absence a
                     JOIN absence_reasons ar ON (ar.id = a.reason)
                   WHERE
                     a.employee_id = in_employee_id AND a.date = in_date AND ar.billable = 'unavailable' :: TIME_STATUS)
  );
END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION staffing_and_billing_overview(in_from_date date, in_to_date date)
RETURNS TABLE (
  year INT,
  week INT,
  from_date date,
  to_date date,
  available_hours NUMERIC,
  billable_hours NUMERIC,
  planned_fg NUMERIC,
  actual_available_hours NUMERIC,
  actual_billable_hours NUMERIC,
  actual_fg NUMERIC,
  deviation_available_hours NUMERIC,
  deviation_billable_hours NUMERIC,
  deviation_fg NUMERIC,
  visibility NUMERIC
) AS
$$
BEGIN
  RETURN QUERY (

select
  x.year,
  x.week,
  x.from_date,
  x.to_date,
  planned.available_hours,
  planned.billable_hours,
  100*(planned.billable_hours / planned.available_hours)                              as planned_fg,
  actual.sum_available_hours                                                          as actual_available_hours,
  actual.sum_billable_hours                                                           as actual_billable_hours,
  100*(actual.sum_billable_hours / actual.sum_available_hours)                        as actual_fg,
  actual.sum_available_hours - planned.available_hours                                as deviation_available_hours,
  actual.sum_billable_hours - planned.billable_hours                                  as deviation_billable_hours,
  100*((actual.sum_billable_hours - planned.billable_hours)/ planned.available_hours) as deviation_fg,
  v.visibility
FROM
  (SELECT
     tt.year                             AS year,
     tt.week                             AS week,
     (SELECT min(date)
      FROM week_dates(tt.year, tt.week)) AS from_date,
     (SELECT max(date)
      FROM week_dates(tt.year, tt.week)) AS to_date

   FROM
     (
       SELECT
         EXTRACT(YEAR FROM dd) :: INTEGER AS year,
         EXTRACT(WEEK FROM dd) :: INTEGER AS week
       FROM
         generate_series(in_from_date, in_to_date, '1 week' :: INTERVAL) dd
     ) tt
  ) x
  LEFT OUTER JOIN reporting_visibility v ON (v.year = x.year AND v.week = x.week),
  accumulated_staffing_hours(x.from_date, x.to_date) planned,
  accumulated_billed_hours(x.from_date, x.to_date) actual

  );
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION accumulated_billed_hours(from_date date, to_date date)
RETURNS TABLE (sum_available_hours NUMERIC, sum_billable_hours NUMERIC) AS
$$
BEGIN
  RETURN QUERY (
    SELECT
         sum(available_hours) :: NUMERIC AS sum_available_hours,
         sum(billable_hours)  :: NUMERIC AS sum_billable_hours
       FROM time_tracking_status (from_date, to_date)
      );
END
$$ LANGUAGE plpgsql;

COMMIT;