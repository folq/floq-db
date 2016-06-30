-- Verify floq:expand_billable_field on pg

BEGIN;

update projects set billable = 'unavailable';

ROLLBACK;
