-- Deploy floq:alter_paid_overtime to pg

BEGIN;

ALTER TABLE paid_overtime ALTER COLUMN paid_date DROP NOT NULL;

COMMIT;
