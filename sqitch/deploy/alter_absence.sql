-- Deploy floq:alter_absence to pg

BEGIN;

ALTER TABLE "absence"
DROP CONSTRAINT "absence_reason_fkey";

COMMIT;
