-- Revert floq:norwegian_holidays_to_2018 from pg

BEGIN;

DELETE FROM holidays
WHERE "date" >= '2016-01-01' AND "date" <= '2018-12-31';

COMMIT;
