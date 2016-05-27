-- Revert floq:add_holidays_table from pg

BEGIN;

DROP TABLE holidays;

COMMIT;
