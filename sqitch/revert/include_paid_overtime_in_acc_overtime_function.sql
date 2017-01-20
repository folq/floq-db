-- Revert floq:include_paid_overtime_in_acc_overtime_function from pg

BEGIN;

-- Fallbacking to next revert statement in sqitch entry: accumulated_overtime

COMMIT;
