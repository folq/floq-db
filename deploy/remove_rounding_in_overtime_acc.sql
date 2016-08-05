-- Deploy floq:remove_rounding_in_overtime_acc to pg

BEGIN;

DROP FUNCTION IF EXISTS accumulated_hours_for_employee(integer, date, date);
CREATE FUNCTION accumulated_hours_for_employee (employee_id int, start_date date, end_date date)
RETURNS float8 AS $alltime_hours$
declare
	alltime_hours float8;
BEGIN
  alltime_hours := (select coalesce(sum(alltime_entries.minutes)/60.0,0.0)::float8 from (
    select *
      from time_entry
      where date between start_date and end_date and employee = employee_id
    ) as alltime_entries);

  RETURN alltime_hours;
END;
$alltime_hours$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS accumulated_overtime_for_employee(integer, date);
CREATE FUNCTION accumulated_overtime_for_employee (employee_id int, end_date date)
RETURNS float8 AS $accumulated_overtime$
declare
	accumulated_overtime float8;
  total_paid_overtime float8;
  date_of_employment date;
  termination_date date;
BEGIN
  termination_date := (select employees.termination_date from employees where id = employee_id);
  date_of_employment := (select employees.date_of_employment from employees where id = employee_id);
  total_paid_overtime := (select coalesce(sum(minutes)/60.0,0)::float8 from paid_overtime WHERE employee = employee_id and date <= end_date);

  if end_date > termination_date then
      raise exception 'end date after employee termination date';
  end if;

  accumulated_overtime := (select hours.employee_hours - hours.business_hours - total_paid_overtime from (
    select * from
      business_hours(date_of_employment, end_date) as business_hours,
      accumulated_hours_for_employee(employee_id, date_of_employment, end_date) as employee_hours
    ) as hours);

  RETURN accumulated_overtime;
END;
$accumulated_overtime$ LANGUAGE plpgsql;

COMMIT;
