-- Deploy floq:upsert_write_off_function to pg
-- requires: balance_tables

BEGIN;

-- This function drops all write_off rows connected to the matched invoice_balance
-- The database-model accepts many-to-one, but not the current view.
CREATE OR REPLACE FUNCTION upsert_write_off(
  IN in_project TEXT,
  IN in_date DATE,
  IN in_minutes INTEGER
)
RETURNS TEXT AS $$
  DECLARE
    invoice_balance_id TEXT;
  BEGIN
    BEGIN
      INSERT INTO invoice_balance (project, date) values(in_project, in_date) RETURNING id INTO invoice_balance_id;
        exception when unique_violation then
          SELECT id from invoice_balance where project=in_project and date=in_date INTO invoice_balance_id;
    END;
    DELETE FROM write_off where invoice_balance=invoice_balance_id;
    INSERT INTO write_off(invoice_balance, minutes) values(invoice_balance_id, in_minutes);
    return invoice_balance_id;
  END;
$$ LANGUAGE plpgsql;

COMMIT;
