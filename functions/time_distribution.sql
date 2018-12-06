CREATE OR REPLACE FUNCTION time_distribution(start_date date, end_date date)
  RETURNS TABLE (billable_hours double precision, nonbillable_hours double precision, unavailable_hours double precision) AS
$$
BEGIN
  RETURN QUERY (
  SELECT
    SUM(CASE WHEN billable = 'billable' then time_entry.minutes else 0 end)/60::double precision as billable_hours,
    SUM(CASE WHEN billable = 'nonbillable' then time_entry.minutes else 0 end)/60::double precision as nonbillable_hours,
    SUM(CASE WHEN billable = 'unavailable' then time_entry.minutes else 0 end)/60::double precision as unavailable_hours
  FROM
    time_entry JOIN projects ON time_entry.project = projects.id
  WHERE
    time_entry.date BETWEEN start_date AND end_date
  );
END
$$ LANGUAGE plpgsql;