CREATE TYPE employee_role_type AS ENUM ('admin');

CREATE TABLE employee_role
(
    id          TEXT CONSTRAINT employee_role_pkey PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id INTEGER REFERENCES employees(id) NOT NULL,
    role_type   employee_role_type NOT NULL,
    created     DATE DEFAULT now()
);