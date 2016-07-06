-- Verify floq:add_unique_to_name_in_customer_table on pg

do $$
BEGIN
  BEGIN
    insert into customers (name) values('somePossibleUnusedNamez3');
    insert into customers (name) values('somePossibleUnusedNamez3');
    EXCEPTION WHEN unique_violation THEN
    	RAISE NOTICE 'SUCCESS: Verified that duplicate name gave us unique_violation';
    	RETURN;
  END;
  RAISE EXCEPTION 'ERROR: Still possible to insert duplicate names.';
END;
$$ language 'plpgsql';
