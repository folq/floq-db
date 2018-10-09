-- Verify floq:add_talks_table on pg

BEGIN;

SELECT id, employee, description, location, talk_date, created FROM talks;

ROLLBACK;
