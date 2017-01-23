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

CREATE OR REPLACE VIEW absence
         AS ( SELECT employee as employee_id, date, project as reason
                FROM staffing
               WHERE is_absence_reason(project) AND NOT is_holiday(date)
            );

-- CREATE TABLE absence (
--   employee_id integer NOT NULL REFERENCES employees(id),

--   date date NOT NULL,
--     CHECK(NOT is_holiday(date)),

--   reason text NOT NULL REFERENCES projects(id),
--     CHECK(is_absence_reason(reason)),

--   comment text NOT NULL DEFAULT '',

--   PRIMARY KEY (employee_id, date)
-- );

-- INSERT INTO absence (employee_id, date, reason)
--   ( SELECT employee, date, project as reason
--       FROM staffing
--      WHERE is_absence_reason(project) AND NOT is_holiday(date)
--   );

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

COMMIT;
