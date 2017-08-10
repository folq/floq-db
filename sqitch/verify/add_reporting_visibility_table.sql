-- Verify floq:add_reporting_visibility_table on pg

BEGIN;

SELECT * FROM reporting_visibility WHERE FALSE;

ROLLBACK;
