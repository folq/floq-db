-- Revert floq:add_timelock_table from pg

BEGIN;

DROP INDEX timelock_events_commit_date_index;
DROP MATERIALIZED VIEW timelock_view;
DROP TABLE timelock_events;

COMMIT;
