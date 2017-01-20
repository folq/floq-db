CREATE OR REPLACE FUNCTION public.upsert_invoice_status(in_project text, in_date date, in_status text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
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
$function$
