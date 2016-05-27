-- Verify floq:norwegian_holidays_to_2018 on pg

BEGIN;

SELECT 1/COUNT(*) FROM holidays
WHERE "date" >= '2016-01-01' AND "date" <= '2018-12-31';

ROLLBACK;
