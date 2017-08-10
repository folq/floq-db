-- Deploy floq:add_reporting_visibility_table to pg

BEGIN;

CREATE TABLE reporting_visibility
(
  year            INT       NOT NULL,
  week            INT       NOT NULL,
  available_hours NUMERIC   NOT NULL,
  billable_hours  NUMERIC   NOT NULL,
  visibility      NUMERIC   NOT NULL,
  time_created    TIMESTAMP NOT NULL,
  UNIQUE (year, week)
);

COMMIT;
