-- Revert floq:auth_roles from pg

BEGIN;

-- XXX Add DDLs here.
DROP ROLE anonymous;

COMMIT;
