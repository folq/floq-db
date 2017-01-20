-- Revert floq:remove_rounding_in_overtime_acc from pg

BEGIN;

-- Fallbacking to next revert statement in sqitch entry: accumulated_overtime

COMMIT;
