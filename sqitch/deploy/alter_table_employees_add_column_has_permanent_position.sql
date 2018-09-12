-- Deploy floq:alter_table_employees_add_column_has_permanent_position to pg

BEGIN;

ALTER TABLE employees
    ADD COLUMN has_permanent_position BOOLEAN DEFAULT true;

COMMIT;
