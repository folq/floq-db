-- Deploy floq:add_invoice_table to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE invoice (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoicenumber TEXT NOT NULL,
  project TEXT NOT NULL REFERENCES projects(id),
  date DATE NOT NULL,
  amount MONEY NOT NULL,
  minutes INTEGER NOT NULL
);

COMMIT;
