CREATE OR REPLACE FUNCTION public.upsert_write_off(in_project text, in_date date, in_minutes integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
  DECLARE
    invoice_balance_id TEXT;
    write_off_id TEXT;
  BEGIN
    BEGIN
      INSERT INTO invoice_balance (project, date) values(in_project, in_date) RETURNING id INTO invoice_balance_id;
        exception when unique_violation then
          SELECT id from invoice_balance where project=in_project and date=in_date INTO invoice_balance_id;
    END;
    DELETE FROM write_off where invoice_balance=invoice_balance_id;
    INSERT INTO write_off(invoice_balance, minutes) values(invoice_balance_id, in_minutes) RETURNING id INTO write_off_id;
    return write_off_id;
  END;
$function$
