-- Revert floq:enable_employee_row_level_security from pg

BEGIN;

DROP POLICY IF EXISTS absence_select_policy ON absence;
DROP POLICY IF EXISTS absence_write_policy ON absence;
DROP POLICY IF EXISTS employees_select_policy ON employees;
DROP POLICY IF EXISTS employees_write_policy ON employees;
DROP POLICY IF EXISTS paid_overtime_select_policy ON paid_overtime;
DROP POLICY IF EXISTS paid_overtime_write_policy ON paid_overtime;
DROP POLICY IF EXISTS time_entry_select_policy ON time_entry;
DROP POLICY IF EXISTS time_entry_write_policy ON time_entry;

DROP POLICY IF EXISTS holidays_select_policy ON holidays;
DROP POLICY IF EXISTS holidays_write_policy ON holidays;
DROP POLICY IF EXISTS timelock_events_select_policy ON timelock_events;
DROP POLICY IF EXISTS timelock_events_write_policy ON timelock_events;
DROP POLICY IF EXISTS vacation_days_select_policy ON vacation_days;
DROP POLICY IF EXISTS vacation_days_write_policy ON vacation_days;

COMMIT;
