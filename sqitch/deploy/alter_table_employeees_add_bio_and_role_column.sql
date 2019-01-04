-- Deploy floq:alter_table_employeees_add_bio_and_role_column to pg

BEGIN;

ALTER TABLE employees
    ADD COLUMN "role" text;

ALTER TABLE employees
    ADD COLUMN bio text;

COMMIT;
