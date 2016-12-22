-- Revert floq:absence_view from pg

BEGIN;

DROP VIEW deviation_per_week;
DROP VIEW staffing_per_week;
DROP VIEW absence_per_week;
DROP VIEW absence_reasons;
DROP VIEW absence;
DROP FUNCTION is_absence_reason(text);
DROP FUNCTION is_weekday(date);
DROP FUNCTION is_holiday(date);

COMMIT;
