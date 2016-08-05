-- Verify floq:remove_rounding_in_overtime_acc on pg

BEGIN;

select * from accumulated_hours_for_employee(1, current_date, current_date);
select * from accumulated_overtime_for_employee(1, current_date);

ROLLBACK;
