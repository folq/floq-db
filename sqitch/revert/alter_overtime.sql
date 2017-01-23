-- Revert floq:alter_overtime from pg

BEGIN;

ALTER TABLE paid_overtime RENAME paid_date to date;
ALTER TABLE paid_overtime DROP registered_date;

COMMIT;
