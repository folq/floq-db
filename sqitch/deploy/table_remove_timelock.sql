-- Deploy floq:table_remove_timelock to pg
-- requires: table_timelock

BEGIN;

DROP TABLE timelock;

COMMIT;
