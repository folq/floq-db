-- Deploy floq:auth_roles to pg

BEGIN;

CREATE ROLE anonymous NOLOGIN;
GRANT anonymous TO root;

COMMIT;
