-- Revert floq:make_billable_nonnullable from pg

BEGIN;

ALTER TABLE "projects" ALTER COLUMN "billable" DROP NOT NULL;



COMMIT;
