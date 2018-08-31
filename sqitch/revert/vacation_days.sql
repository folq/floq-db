-- Revert floq:vacation_days from pg

BEGIN;

DROP TABLE vacation_days;

COMMIT;
