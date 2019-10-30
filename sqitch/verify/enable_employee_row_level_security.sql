-- Verify floq:enable_employee_row_level_security from pg

BEGIN;

ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'absence';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'employees';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'paid_overtime';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'time_entry';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'holidays';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'timelock_events';
ASSERT SELECT COUNT(*) = 2 FROM pg_catalog.pg_policies WHERE tablename = 'vacation_days';

ROLLBACK;