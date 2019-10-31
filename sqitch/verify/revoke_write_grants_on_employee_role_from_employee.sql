-- Verify floq:revoke_write_grants_on_employee_role_from_employee on pg

DO
$$
    DECLARE
    BEGIN
        ASSERT (SELECT 1
                FROM information_schema.role_table_grants
                WHERE grantee = 'employee'
                  AND table_name = 'employee_role'
                  AND with_hierarchy = 'YES'
                  AND privilege_type = 'SELECT');
        ASSERT 0 = (SELECT 1
                    FROM information_schema.role_table_grants
                    WHERE grantee = 'employee'
                      AND table_name = 'employee_role'
                      AND privilege_type = 'INSERT'
                    UNION
                    SELECT 0);
        ASSERT 0 = (SELECT 1
                    FROM information_schema.role_table_grants
                    WHERE grantee = 'employee'
                      AND table_name = 'employee_role'
                      AND privilege_type = 'UPDATE'
                    UNION
                    SELECT 0);
        ASSERT 0 = (SELECT 1
                    FROM information_schema.role_table_grants
                    WHERE grantee = 'employee'
                      AND table_name = 'employee_role'
                      AND privilege_type = 'DELETE'
                    UNION
                    SELECT 0);
    END
$$;
