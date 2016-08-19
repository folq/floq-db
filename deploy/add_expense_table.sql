-- Deploy floq:add_expense_table to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE expense (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer INTEGER REFERENCES customers(id),
  project TEXT REFERENCES projects(id),
  date DATE NOT NULL,
  amount MONEY NOT NULL,
  comment TEXT
);

COMMIT;
