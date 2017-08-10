-- Revert floq:add_reporting_visibility_table from pg

BEGIN;

DROP TABLE reporting_visibility;

COMMIT;
