-- Verify floq:add_image_url_to_employees on pg

BEGIN;

select image_url from employees where false;

ROLLBACK;
