-- Revert floq:alter_table_employeees_add_bio_and_role_column from pg

BEGIN;

ALTER TABLE employees
    DROP COLUMN "role";

ALTER TABLE employees
    DROP COLUMN bio;

COMMIT;
