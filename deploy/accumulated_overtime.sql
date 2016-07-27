-- Deploy floq:accumulated_overtime to pg

BEGIN;

CREATE OR REPLACE FUNCTION accumulated_hours_for_employee (employee_id int, start_date date, end_date date)
RETURNS integer AS $alltime_hours$
declare
	alltime_hours float8;
BEGIN
  alltime_hours := (select sum(alltime_entries.minutes)/60 from (
    select *
      from time_entry
      where date between start_date and end_date and employee = employee_id
    ) as alltime_entries);

  RETURN alltime_hours;
END;
$alltime_hours$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION accumulated_overtime_for_employee (employee_id int, end_date date)
RETURNS integer AS $accumulated_overtime$
declare
	accumulated_overtime float8;
  date_of_employment date;
  termination_date date;
BEGIN
  termination_date := (select employees.termination_date from employees where id = employee_id);
  date_of_employment := (select employees.date_of_employment from employees where id = employee_id);

  if end_date > termination_date then
      raise exception 'end date after employee termination date';
  end if;

  accumulated_overtime := (select hours.employee_hours - hours.business_hours from (
    select * from
      business_hours(date_of_employment, end_date) as business_hours,
      accumulated_hours_for_employee(employee_id, date_of_employment, end_date) as employee_hours
    ) as hours);

  RETURN accumulated_overtime;
END;
$accumulated_overtime$ LANGUAGE plpgsql;

COMMIT;
