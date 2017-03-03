-- Revert floq:alter_absence from pg

BEGIN;

ALTER TABLE "absence"
ADD FOREIGN KEY (reason)
REFERENCES projects(id);

COMMIT;
