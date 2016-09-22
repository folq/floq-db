-- Verify floq:alter_table_invoice_balance_extend_date_contraint on pg

BEGIN;

do $$
BEGIN
  insert into customers (id, name) values('c_id','c_name');
  insert into projects (id, name, billable, customer) values ('p_id1','p_name','billable', 'c_id');
  insert into projects (id, name, billable, customer) values ('p_id2','p_name','billable', 'c_id');
  insert into invoice_balance(project, date) values ('p_id1','2000-01-01');
  insert into invoice_balance(project, date) values ('p_id2','2000-01-01');
  BEGIN
    insert into projects (id, name, billable, customer) values ('p_id3','p_name','billable', 'c_id');
    insert into invoice_balance(project, date) values ('p_id3','2000-01-01');
    insert into invoice_balance(project, date) values ('p_id3','2000-01-01');
    EXCEPTION WHEN unique_violation THEN
      -- SUCCESS: Verified that duplicate name gave us unique_violation
      RETURN;
  END;
  RAISE EXCEPTION 'ERROR: Still possible to insert duplicate names.';
END;
$$ language 'plpgsql';

ROLLBACK;
