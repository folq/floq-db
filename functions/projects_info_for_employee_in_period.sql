CREATE OR REPLACE FUNCTION public.projects_info_for_employee_in_period(employee_id integer, date_range text)
RETURNS TABLE(
  id text,
  name text,
  active boolean,
  customer_id text,
  customer_name text
) 
LANGUAGE sql IMMUTABLE STRICT AS 
$function$
SELECT
  p.id AS id,
  p.name AS name,
  p.active AS active,
  c.id AS customer_id,
  c.name AS customer_name
from
  projects AS p
  JOIN customers AS c ON p.customer = c.id
WHERE
  p.id IN (
    SELECT
      DISTINCT t.project
    FROM
      time_entry AS t
    WHERE
      t.employee = employee_id
      AND date_range::daterange @> t.date
  ) 
$function$