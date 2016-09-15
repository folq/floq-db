-- Revert floq:balance_tables from pg

BEGIN;

DROP TABLE write_off;
CREATE TABLE write_off (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  project TEXT NOT NULL REFERENCES projects(id),
  from_date DATE NOT NULL,  --inclusive
  to_date DATE NOT NULL, --exclusive
  minutes INTEGER NOT NULL -- consistent with time_entry
);

DROP TABLE expense;
drop type expense_type;
CREATE TABLE expense (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  project TEXT REFERENCES projects(id),
  date DATE NOT NULL,
  amount MONEY NOT NULL,
  comment TEXT
);

DROP TABLE invoice_balance;
CREATE TABLE invoice (
  id TEXT PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoicenumber TEXT NOT NULL,
  project TEXT NOT NULL REFERENCES projects(id),
  date DATE NOT NULL,
  amount MONEY NOT NULL,
  minutes INTEGER NOT NULL
);

COMMIT;
