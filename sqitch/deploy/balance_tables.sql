-- Deploy floq:balance_tables to pg
-- requires: write_off_table
-- required: invoice_table
-- required: expense_table

BEGIN;

DROP TABLE invoice;
CREATE TABLE invoice_balance (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  project TEXT NOT NULL REFERENCES projects(id),
  date DATE NOT NULL,
  amount MONEY NOT NULL DEFAULT 0,
  minutes INTEGER NOT NULL DEFAULT 0,
  created DATE NOT NULL DEFAULT now(),
  invoicenumber TEXT
);
CREATE UNIQUE INDEX unique_invoicenumber ON invoice_balance (invoicenumber);
CREATE UNIQUE INDEX unique_invoicedate ON invoice_balance (date);

CREATE TYPE expense_type AS ENUM ('subcontractor', 'other');
DROP TABLE expense;
CREATE TABLE expense (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoice_balance TEXT NOT NULL REFERENCES invoice_balance(id),
  type expense_type NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  created DATE NOT NULL DEFAULT now(),
  comment TEXT
);

DROP TABLE write_off;
CREATE TABLE write_off (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoice_balance TEXT NOT NULL REFERENCES invoice_balance(id),
  minutes INTEGER NOT NULL,
  created DATE NOT NULL DEFAULT now()
);

COMMIT;
