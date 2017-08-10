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


COMMIT;