-- Deploy floq:drop_timelock_view to pg

BEGIN;

DROP MATERIALIZED VIEW timelock_view;

COMMIT;
