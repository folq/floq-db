-- Verify floq:table_remove_timelock on pg

BEGIN;

SELECT 1/(count(*)-1)
  FROM  pg_catalog.pg_tables
  WHERE schemaname = 'public'
  AND   tablename  = 'timelock';

ROLLBACK;
