-- Deploy floq:add_image_url_to_employees to pg

BEGIN;

alter table employees add column image_url text;

COMMIT;
