-- Deploy floq:add_holidays_table to pg

BEGIN;

    CREATE TABLE holidays (
        "date" date,
        "name" text,
        PRIMARY KEY ("date")
    );

COMMIT;
