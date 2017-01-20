-- Deploy floq:upsert_invoice_balance_function to pg
-- requires: alter_invoice_table_money_to_numeric

BEGIN;

CREATE OR REPLACE FUNCTION upsert_invoice_balance(
  IN in_project TEXT,
  IN in_date DATE,
  IN in_minutes INTEGER,
  IN in_money NUMERIC
)
RETURNS TEXT AS $$
  DECLARE
    invoice_balance_id TEXT;
  BEGIN
    BEGIN
      INSERT INTO invoice_balance (project, date, minutes, amount) values(in_project, in_date, in_minutes, in_money) RETURNING id INTO invoice_balance_id;
        exception when unique_violation then
          UPDATE invoice_balance SET minutes=in_minutes, amount=in_money where project=in_project and date=in_date RETURNING id INTO invoice_balance_id;
    END;
    return invoice_balance_id;
  END;
$$ LANGUAGE plpgsql;

COMMIT;
