-- Deploy floq:alter_overtime to pg

BEGIN;

ALTER TABLE paid_overtime RENAME date to paid_date;
ALTER TABLE paid_overtime ADD registered_date date NOT NULL DEFAULT NOW();

COMMIT;
