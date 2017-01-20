-- Deploy floq:add_function_remove_days_from_week to pg

BEGIN;

CREATE OR REPLACE FUNCTION remove_days_from_week(
 IN in_employee INTEGER,
 IN in_project TEXT,
 IN in_week INTEGER,
 IN in_days INTEGER,
 IN in_year INTEGER DEFAULT date_part('year', CURRENT_DATE)
)
RETURNS setof DATE AS $$
DECLARE
 last_date DATE := week_to_date(in_year, in_week)+6;
 removed_days integer := 0;
BEGIN
 IF (in_week < 0 OR in_week > 53) then RAISE numeric_value_out_of_range USING MESSAGE = 'week-parameter has to be within: [0,53] but was ' || in_week; END IF;
 IF (in_days < 1 OR in_days > 7) then RAISE numeric_value_out_of_range USING MESSAGE = 'days-parameter has to be within: [1,7] but was ' || in_days; END IF;
 FOR i IN 0..6 LOOP
   BEGIN
     IF EXISTS (select 1 from staffing  where employee=in_employee and project = in_project and date=last_date-i) THEN
       delete from staffing where employee = in_employee AND date = last_date-i;
       IF NOT FOUND then RAISE exception 'Unknown error when deleting employee=%, date=%', in_employee, last_date - i; END IF;
       removed_days = removed_days + 1;
       return next last_date - i;
       IF (removed_days = in_days) then return; END IF;
     END IF;
   END;
 END LOOP;
 RAISE unique_violation USING MESSAGE = 'The requested week only has ' || removed_days || ' staffed days';
END;
$$ LANGUAGE plpgsql;

COMMIT;
