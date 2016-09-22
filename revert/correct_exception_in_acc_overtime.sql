-- Revert floq:correct_exception_in_acc_overtime from pg

BEGIN;

-- Fallbacking to next revert statement in sqitch entry: accumulated_overtime

COMMIT;
