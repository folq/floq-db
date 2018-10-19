-- Deploy floq:add_talks_table to pg

BEGIN;

-- DDL generated by Postico 1.4.2
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE talks (
    employee integer REFERENCES employees(id),
    talk_date date NOT NULL,
    title text NOT NULL,
    description text,
    location text NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    id SERIAL PRIMARY KEY
);

COMMIT;
