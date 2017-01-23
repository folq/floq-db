-- Verify floq:time_tracking_tables on pg

BEGIN;

SELECT uuid_generate_v4();
SELECT * FROM time_entry WHERE FALSE;
SELECT * FROM projects WHERE FALSE;
SELECT * FROM customers WHERE FALSE;

ROLLBACK;
