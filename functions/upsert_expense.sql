CREATE OR REPLACE FUNCTION public.upsert_expense(in_project text, in_date date, in_type text, in_money numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
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
$function$
