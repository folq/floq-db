-- Revert floq:add_image_url_to_employees from pg

BEGIN;

alter table employees drop column image_url;

COMMIT;
