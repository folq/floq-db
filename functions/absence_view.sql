-- Deploy floq:absence_view to pg
-- requires: norwegian_holidays_to_2018
-- requires: staffing_table
-- requires: employees_table

BEGIN;

CREATE OR REPLACE FUNCTION is_holiday(d date)
        RETURNS boolean AS
$$
BEGIN
  RETURN EXISTS (SELECT * FROM holidays WHERE holidays.date = d);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_weekday(d date)
        RETURNS boolean AS
$$
BEGIN
  RETURN NOT (    EXTRACT(dow FROM d) = 0
               OR EXTRACT(dow FROM d) = 6
             );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_absence_reason(reason text)
        RETURNS boolean AS
$$
BEGIN
  RETURN (    reason = 'FER1000'
           OR reason = 'SYK1001'
           OR reason = 'SYK1002'
           OR reason = 'PER1000'
           OR reason = 'PER1001'
         );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW absence_reasons
         AS ( SELECT id, name
                FROM projects
               WHERE is_absence_reason(id)
            );

CREATE OR REPLACE VIEW absence_per_week
         AS ( SELECT employee_id,
                     employee_absence.year,
                     employee_absence.week,
                     (employee_absence.days + COUNT(holidays_absence.week)) AS days
                FROM ( SELECT employee_id,
                              EXTRACT(YEAR FROM date) AS year,
                              EXTRACT(WEEK FROM date) AS week,
                              COUNT(employee_id) AS days
                         FROM absence
                        WHERE is_weekday(date)
                     GROUP BY employee_id, year, week
                     ) employee_absence
           LEFT JOIN ( SELECT EXTRACT(YEAR FROM date) AS year,
                              EXTRACT(WEEK FROM holidays.date) as week
                         FROM holidays
                        WHERE is_weekday(holidays.date)
                     ) holidays_absence
                  ON employee_absence.year = holidays_absence.year
                 AND employee_absence.week = holidays_absence.week
            GROUP BY employee_id,
                     employee_absence.year,
                     employee_absence.week,
                     employee_absence.days,
                     holidays_absence.week
            );

CREATE OR REPLACE VIEW staffing_per_week
         AS ( SELECT employee AS employee_id,
                     EXTRACT(YEAR FROM date) AS year,
                     EXTRACT(WEEK FROM date) AS week,
                     project AS project_id,
                     COUNT(employee) AS days
                FROM staffing
               WHERE NOT is_absence_reason(project)
            GROUP BY employee, year, week, project
            );

CREATE OR REPLACE VIEW deviation_per_week
         AS ( SELECT apw.employee_id,
                     apw.year,
                     apw.week,
                     (5 - (SUM(apw.days) + SUM(spw.days))) AS delta_days -- If >0, then you have staffed more what is available
                FROM absence_per_week AS apw
          INNER JOIN staffing_per_week AS spw
                  ON (     apw.employee_id = spw.employee_id
                       AND apw.year = spw.year
                       AND apw.week = spw.week
                     )
            GROUP BY apw.employee_id, apw.year, apw.week
            );

CREATE OR REPLACE FUNCTION week_dates(in_year integer, in_week integer)
RETURNS TABLE ( date date ) AS
$$
BEGIN
  RETURN QUERY SELECT date_trunc('week', (in_year::text || '-1-4')::timestamp)::date
    + 7 * (in_week - 1)  -- fix off-by-one
    + generate_series (0, 6);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION available_dates(e integer, in_year integer, in_week integer)
RETURNS TABLE ( available_date date ) AS
$$
BEGIN
  RETURN QUERY
  SELECT date AS available_date
    FROM week_dates(in_year, in_week)
   WHERE is_weekday(date) AND NOT is_holiday(date)
  EXCEPT ( SELECT staffing.date AS date FROM staffing WHERE employee = e
            UNION
           SELECT absence.date AS date FROM absence WHERE employee_id = e
         );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fix_staffing_on_weekends_and_holidays()
RETURNS TABLE (employee integer, year integer, week integer, count integer, project text) AS
$$
BEGIN
  RETURN QUERY (
    WITH move_candidates AS (
        SELECT staffing.employee,
               EXTRACT(YEAR FROM staffing.date) AS year,
               EXTRACT(WEEK FROM staffing.date) AS week,
               COUNT(staffing.date) AS count,
               staffing.project
          FROM staffing
         WHERE is_holiday(staffing.date) OR NOT is_weekday(staffing.date)
      GROUP BY staffing.employee, year, week, staffing.project
      ), reassigned_candidates AS (
        SELECT * FROM move_candidates s1 LEFT JOIN LATERAL (
          SELECT available_date
            FROM available_dates(s1.employee::integer, s1.year::integer, s1.week::integer)
           LIMIT s1.count
        ) s2 ON true
      ), moved_candidates AS (
        INSERT INTO staffing (employee, date, project)
          ( SELECT reassigned_candidates.employee,
                   available_date AS date,
                   reassigned_candidates.project
              FROM reassigned_candidates
             WHERE available_date IS NOT NULL
          )
      ), old_candidates AS (
        DELETE FROM staffing
              WHERE is_holiday(staffing.date) OR NOT is_weekday(staffing.date)
      )
    SELECT t.employee,
           t.year  ::integer,
           t.week  ::integer,
           t.count ::integer,
           t.project
      FROM reassigned_candidates t
     WHERE t.available_date IS NULL
  );
END
$$ LANGUAGE plpgsql;

COMMIT;
