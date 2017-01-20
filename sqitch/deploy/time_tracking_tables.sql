-- Deploy floq:time_tracking_tables to pg
-- requires: employees_table

BEGIN;

CREATE EXTENSION "uuid-ossp";

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    billable BOOLEAN,
    customer INTEGER NOT NULL REFERENCES customers(id)
);

CREATE TABLE time_entry (
    id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee INTEGER NOT NULL REFERENCES employees(id),
    creator INTEGER NOT NULL REFERENCES employees(id),
    minutes INTEGER,
    project INTEGER NOT NULL REFERENCES projects(id),
    date DATE NOT NULL,
    created TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Block range indexes (BRINs) are designed to handle very large tables in
-- which the rows’ natural sort order correlates to certain column values. In
-- this case, dates for time entries
CREATE INDEX time_entry_date_index ON time_entry USING BRIN (date);

COMMIT;
