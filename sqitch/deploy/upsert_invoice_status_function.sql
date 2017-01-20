-- Deploy floq:upsert_invoice_status_function to pg
-- requires: alter_table_invoice_balance_add_col_status

BEGIN;

CREATE OR REPLACE FUNCTION upsert_invoice_status(
  IN in_project TEXT,
  IN in_date DATE,
  IN in_status TEXT
)
RETURNS TEXT AS $$
  DECLARE
    invoice_balance_id TEXT;
  BEGIN
    BEGIN
      INSERT INTO invoice_balance (project, date, status) values(in_project, in_date, in_status::invoice_status) RETURNING id INTO invoice_balance_id;
        exception when unique_violation then
          UPDATE invoice_balance SET status = in_status::invoice_status where project=in_project and date=in_date RETURNING id INTO invoice_balance_id;
    END;
    return invoice_balance_id;
  END;
$$ LANGUAGE plpgsql;

COMMIT;
