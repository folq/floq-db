-- Verify floq:project_sdg on pg

BEGIN;

SELECT * FROM project_sdg_events WHERE FALSE;

ROLLBACK;
