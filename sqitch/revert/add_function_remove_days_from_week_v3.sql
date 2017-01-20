-- Revert floq:add_function_remove_days_from_week from pg

BEGIN;

DROP FUNCTION IF EXISTS remove_days_from_week(integer,text,integer,date);

CREATE OR REPLACE FUNCTION remove_days_from_week(
 IN in_employee INTEGER,
 IN in_project TEXT,
 IN in_days INTEGER,
 IN in_start_of_week DATE DEFAULT CURRENT_DATE + 1 - (EXTRACT(DOW FROM CURRENT_DATE))::integer
)
RETURNS setof DATE AS $$
DECLARE
 removed_days integer := 0;
BEGIN
 IF (in_days < 1 OR in_days > 7) then RAISE numeric_value_out_of_range USING MESSAGE = 'days-parameter has to be within: [1,7] but was ' || in_days; END IF;
 FOR i IN REVERSE 6..0 LOOP
   BEGIN
     IF EXISTS (select 1 from staffing where employee=in_employee and project = in_project and date=in_start_of_week-i) THEN
       delete from staffing where employee = in_employee AND date = in_start_of_week-i;
       IF NOT FOUND then RAISE exception 'Unknown error when deleting employee=%, date=%', in_employee, in_start_of_week - i; END IF;
       removed_days = removed_days + 1;
       return next in_start_of_week - i;
       IF (removed_days = in_days) then return; END IF;
     END IF;
   END;
 END LOOP;
 RAISE unique_violation USING MESSAGE = 'The requested week only has ' || removed_days || ' staffed days';
END;
$$ LANGUAGE plpgsql;

COMMIT;
