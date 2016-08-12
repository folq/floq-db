-- Revert floq:add_function_add_days_to_week from pg

BEGIN;

DROP FUNCTION IF EXISTS add_days_to_week(integer,text,integer,date);
DROP FUNCTION IF EXISTS week_to_date(integer,integer,integer);

CREATE OR REPLACE FUNCTION week_to_date(
  IN in_year INTEGER,
  IN in_week INTEGER,
  IN in_dow INTEGER DEFAULT NULL
)
RETURNS DATE AS $$
/*******************************************************************************
Function Name: week_to_date
In-coming Params:
  - in_year INTEGER
  - in_week INTEGER
  - in_dow INTEGER
Description:
  Takes the day of the week (0 to 6 with 0 being Sunday), week of the year, and
  year.  Returns the corresponding date.

Created On: 2011-12-21
Revised On: 2013-02-01 (by ElDiablo)
Author: Chris West
Url: http://cwestblog.com/2011/12/21/postgresql-week-number-to-date/
 ******************************************************************************/
BEGIN
  RETURN to_timestamp('1 ' || in_year, 'IW IYYY')::DATE + (COALESCE(in_dow, 1) + 6) % 7 + 7 * in_week - 7;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_days_to_week(
 IN in_employee INTEGER,
 IN in_project TEXT,
 IN in_week INTEGER,
 IN in_days INTEGER,
 IN in_year INTEGER DEFAULT date_part('year', CURRENT_DATE)
)
RETURNS setof DATE AS $$
DECLARE
 first_date DATE := week_to_date(in_year, in_week);
 added_days integer := 0;
BEGIN
 IF (in_week < 0 OR in_week > 53) then RAISE numeric_value_out_of_range USING MESSAGE = 'week-parameter has to be within: [0,53] but was ' || in_week; END IF;
 IF (in_days < 1 OR in_days > 7) then RAISE numeric_value_out_of_range USING MESSAGE = 'days-parameter has to be within: [1,7] but was ' || in_days; END IF;
 FOR i IN 0..6 LOOP
   BEGIN
     IF NOT EXISTS (select 1 from staffing  where employee=in_employee and date=first_date+i) THEN
       insert into staffing (employee, project, date) values(in_employee, in_project, first_date+i);
       IF NOT FOUND then RAISE exception 'Unknown error when inserting eployee=%, project=%, date=%', in_employee, in_project, first_date+i; END IF;
       added_days = added_days + 1;
       return next first_date + i;
       IF (added_days = in_days) then return; END IF;
     END IF;
   END;
 END LOOP;
 RAISE unique_violation USING MESSAGE = 'The requested week only has ' || added_days || ' unstaffed days';
END;
$$ LANGUAGE plpgsql;

COMMIT;
