CREATE OR REPLACE FUNCTION public.accumulated_overtime_for_employee(employee_id integer, end_date date)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
declare
	accumulated_overtime float8;
  total_paid_overtime float8;
  date_of_employment date;
  termination_date date;
BEGIN
  termination_date := (select employees.termination_date from employees where id = employee_id);
  date_of_employment := (select employees.date_of_employment from employees where id = employee_id);
  total_paid_overtime := (select coalesce(sum(minutes)/60.0,0)::float8 from paid_overtime WHERE employee = employee_id and paid_date <= end_date);

  if end_date > termination_date then
      raise invalid_parameter_value USING MESSAGE = 'end date after employee termination date';
  end if;

  accumulated_overtime := (select hours.employee_hours - hours.business_hours - total_paid_overtime from (
    select * from
      business_hours(date_of_employment, end_date) as business_hours,
      accumulated_hours_for_employee(employee_id, date_of_employment, end_date) as employee_hours
    ) as hours);

  RETURN accumulated_overtime;
END;
$function$
