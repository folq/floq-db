CREATE OR REPLACE FUNCTION time_distribution(start_date date, end_date date)
  RETURNS TABLE (billable_hours double precision, nonbillable_hours double precision, unavailable_hours double precision) AS
$$
BEGIN
  RETURN QUERY (
  SELECT
    SUM(CASE WHEN billable = 'billable' then 1 else 0 end)*7.5::double precision as billable_hours,
    SUM(CASE WHEN billable = 'nonbillable' then 1 else 0 end)*7.5::double precision as nonbillable_hours,
    SUM(CASE WHEN billable = 'unavailable' then 1 else 0 end)*7.5::double precision as unavailable_hours
  FROM
    staffing as s,
    projects as p
  WHERE
    s.project = p.id AND
    s.date BETWEEN start_date AND end_date
  );
END
$$ LANGUAGE plpgsql;
