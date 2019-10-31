-- Verify floq:enable_employee_row_level_security from pg

BEGIN;

-- divide-by-zero if policy does not exist
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'absence';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'employees';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'paid_overtime';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'time_entry';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'holidays';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'invoice_balance';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'timelock_events';
SELECT 1/COUNT(*) FROM pg_catalog.pg_policies WHERE tablename = 'vacation_days';

ROLLBACK;