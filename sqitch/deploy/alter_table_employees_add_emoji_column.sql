-- Deploy floq:alter_table_employees_add_emoji_column to pg

BEGIN;

ALTER TABLE employees
    ADD COLUMN emoji EMOJI;

COMMIT;
