-- Revert floq:absence_spent from pg

BEGIN;

DROP VIEW absence_spent CASCADE;

COMMIT;
