-- Revert floq:paid_overtime_table from pg

BEGIN;

DROP TABLE paid_overtime;

COMMIT;
