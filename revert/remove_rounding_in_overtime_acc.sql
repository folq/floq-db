-- Revert floq:remove_rounding_in_overtime_acc from pg

BEGIN;

DROP FUNCTION IF EXISTS accumulated_hours_for_employee(int, date, date);
DROP FUNCTION IF EXISTS accumulated_overtime_for_employee(int, date);

COMMIT;
