-- Deploy floq:make_billable_nonnullable to pg

BEGIN;

ALTER TABLE "projects" ALTER COLUMN "billable" SET NOT NULL;


COMMIT;
