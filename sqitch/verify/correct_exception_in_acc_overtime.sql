-- Verify floq:correct_exception_in_acc_overtime on pg

BEGIN;

select * from accumulated_overtime_for_employee(1, current_date);

ROLLBACK;
