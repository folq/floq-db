-- Verify floq:auth_roles on pg

BEGIN;

-- divide-by-zero if role does not exist
SELECT 1/COUNT(*)
FROM information_schema.applicable_roles
WHERE grantee = 'root'
 AND role_name = 'anonymous'
 AND is_grantable = 'NO';

ROLLBACK;
