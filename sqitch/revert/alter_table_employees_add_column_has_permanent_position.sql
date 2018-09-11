-- Revert floq:alter_table_employees_add_column_has_permanent_position to pg

BEGIN;

ALTER TABLE employees
    DROP COLUMN has_permanent_position;

COMMIT;
