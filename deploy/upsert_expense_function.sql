-- Deploy floq:upsert_expense_function to pg
-- requires: balance_tables

BEGIN;

-- This function drops all expense rows connected to the matched invoice_balance and type
-- The database-model accepts many-to-one, but not the current MVP (sep 2016).
CREATE OR REPLACE FUNCTION upsert_expense(
  IN in_project TEXT,
  IN in_date DATE,
  IN in_type text,
  IN in_money NUMERIC
)
RETURNS TEXT AS $$
  DECLARE
    invoice_balance_id TEXT;
    expense_id TEXT;
  BEGIN
    BEGIN
      INSERT INTO invoice_balance (project, date) values(in_project, in_date) RETURNING id INTO invoice_balance_id;
        exception when unique_violation then
          SELECT id from invoice_balance where project=in_project and date=in_date INTO invoice_balance_id;
    END;
    DELETE FROM expense where invoice_balance=invoice_balance_id and type=in_type::expense_type;
    INSERT INTO expense(invoice_balance, type, amount) values(invoice_balance_id, in_type::expense_type, in_money) RETURNING id INTO expense_id;
    return expense_id;
  END;
$$ LANGUAGE plpgsql;

COMMIT;
