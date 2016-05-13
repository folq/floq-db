-- Deploy floq:employees_table to pg

BEGIN;

CREATE TYPE gender AS ENUM ('male', 'female', 'other');

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  title TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  gender gender NOT NULL,
  birth_date DATE NOT NULL,
  date_of_employment DATE,
  termination_date DATE,
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  emergency_contact_relation TEXT,
  address TEXT,
  postal_code TEXT,
  city TEXT
);

CREATE UNIQUE INDEX unique_employee_email ON employees (email);

COMMIT;
