-- Revert floq:time_tracking_tables from pg

BEGIN;

DROP INDEX time_entry_date_index;
DROP TABLE time_entry;
DROP TABLE projects;
DROP TABLE customers;

DROP EXTENSION "uuid-ossp";

COMMIT;
