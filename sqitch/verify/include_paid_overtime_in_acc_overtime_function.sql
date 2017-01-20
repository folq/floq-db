-- Verify floq:include_paid_overtime_in_acc_overtime_function on pg

BEGIN;

select * from accumulated_overtime_for_employee(1, current_date);

ROLLBACK;
