CREATE OR REPLACE FUNCTION public.upsert_invoice_balance(in_project text, in_date date, in_minutes integer, in_money numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
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
$function$
