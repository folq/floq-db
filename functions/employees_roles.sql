CREATE OR REPLACE FUNCTION public.employees_roles()
    RETURNS TABLE(id INTEGER, first_name TEXT, last_name TEXT, email TEXT, roles employee_role_type[])
    LANGUAGE sql
    STABLE STRICT
AS $function$
SELECT employees.id, first_name, last_name, email, array_remove(array_agg(role_type), NULL) AS roles
FROM employees LEFT OUTER JOIN employee_role ON (employees.id = employee_role.employee_id)
GROUP BY employees.id
ORDER BY employees.id
$function$;

CREATE OR REPLACE FUNCTION public.employees_roles(id_param INTEGER)
    RETURNS TABLE(id INTEGER, first_name TEXT, last_name TEXT, email TEXT, roles employee_role_type[])
    LANGUAGE sql
    STABLE STRICT
AS $function$
SELECT employees.id, first_name, last_name, email, array_remove(array_agg(role_type), NULL) AS roles
FROM employees LEFT OUTER JOIN employee_role ON (employees.id = employee_role.employee_id)
WHERE employees.id = id_param
GROUP BY employees.id
ORDER BY employees.id
$function$;