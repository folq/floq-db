-- Revert floq:alter_paid_overtime from pg

BEGIN;

ALTER TABLE paid_overtime ALTER COLUMN paid_date SET NOT NULL;

COMMIT;
