-- Revert floq:expand_billable_field from pg

BEGIN;

alter table "projects"
  alter column "billable" set data type boolean using (
    case
        when billable='billable' then true
        else false
    end
  );

drop type time_status;

COMMIT;
