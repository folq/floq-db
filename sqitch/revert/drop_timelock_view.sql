-- Revert floq:drop_timelock_view from pg

BEGIN;

CREATE MATERIALIZED VIEW timelock_view AS
WITH tl AS (
    SELECT *, row_number() over(PARTITION BY employee ORDER BY created DESC) as row_number
    FROM timelock_events
)
SELECT id, created, creator, employee, commit_date
FROM tl
WHERE row_number = 1;

CREATE UNIQUE INDEX ON timelock_view (employee);

COMMIT;
