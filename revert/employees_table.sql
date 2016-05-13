-- Revert floq:employees_table from pg

BEGIN;

DROP TABLE employees;
DROP TYPE gender;

COMMIT;
