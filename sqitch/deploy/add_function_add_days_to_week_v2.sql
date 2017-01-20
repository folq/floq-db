-- Deploy floq:add_function_add_days_to_week to pg

BEGIN;

DROP FUNCTION IF EXISTS week_to_date(integer,integer,integer);

DROP FUNCTION IF EXISTS add_days_to_week(integer,text,integer,integer,integer);

CREATE OR REPLACE FUNCTION add_days_to_week(
 IN in_employee INTEGER,
 IN in_project TEXT,
 IN in_days INTEGER,
 IN in_start_of_week DATE DEFAULT CURRENT_DATE + 1 - (EXTRACT(DOW FROM CURRENT_DATE))::integer
)
RETURNS setof DATE AS $$
DECLARE
 added_days integer := 0;
BEGIN
 IF (in_days < 1 OR in_days > 7) then RAISE numeric_value_out_of_range USING MESSAGE = 'days-parameter has to be within: [1,7] but was ' || in_days; END IF;
 FOR i IN 0..6 LOOP
   BEGIN
     IF NOT EXISTS (select 1 from staffing where employee=in_employee and date=in_start_of_week+i) THEN
       insert into staffing (employee, project, date) values(in_employee, in_project, in_start_of_week+i);
       IF NOT FOUND then RAISE exception 'Unknown error when inserting eployee=%, project=%, date=%', in_employee, in_project, in_start_of_week+i; END IF;
       added_days = added_days + 1;
       return next in_start_of_week + i;
       IF (added_days = in_days) then return; END IF;
     END IF;
   END;
 END LOOP;
 RAISE unique_violation USING MESSAGE = 'The requested week only has ' || added_days || ' unstaffed days';
END;
$$ LANGUAGE plpgsql;

COMMIT;
