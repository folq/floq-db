-- Revert floq:project_sdg from pg

BEGIN;

DROP TABLE project_sdg_events;

COMMIT;
