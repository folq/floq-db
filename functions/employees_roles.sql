CREATE OR REPLACE FUNCTION public.employees_roles(id_param INTEGER)
    RETURNS TABLE(employee employees, roles employee_role_type[])
    LANGUAGE SQL IMMUTABLE STRICT
AS $function$
    SELECT employees, array_remove(array_agg(role_type), NULL) AS roles
    FROM employees LEFT OUTER JOIN employee_role ON (employees.id = employee_role.employee_id)
    WHERE employees.id = id_param
    GROUP BY employees.id
$function$;

CREATE OR REPLACE FUNCTION public.employees_roles()
    RETURNS TABLE(employee employees, roles employee_role_type[])
    LANGUAGE SQL IMMUTABLE STRICT
AS $function$
    SELECT employees_roles(employees.id)
    FROM employees
    ORDER BY employees.id
$function$;

CREATE OR REPLACE FUNCTION public.employees_roles(email_param TEXT)
    RETURNS TABLE(employee employees, roles employee_role_type[])
    LANGUAGE SQL IMMUTABLE STRICT
AS $function$
    SELECT employees, array_remove(array_agg(role_type), NULL) AS roles
    FROM employees LEFT OUTER JOIN employee_role ON (employees.id = employee_role.employee_id)
    WHERE employees.email = email_param
    GROUP BY employees.id
$function$;
