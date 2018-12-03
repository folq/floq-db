-- Verify floq:absence_spent on pg

BEGIN;

SELECT * FROM absence_spent WHERE FALSE;

ROLLBACK;