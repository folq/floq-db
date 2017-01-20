-- Verify floq:accumulated_overtime on pg

BEGIN;

select * from accumulated_hours_for_employee(1, current_date, current_date);
select * from accumulated_overtime_for_employee(1, current_date);

ROLLBACK;
