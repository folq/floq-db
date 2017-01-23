-- Deploy floq:expand_billable_field to pg

BEGIN;

create type time_status as enum ('billable', 'nonbillable', 'unavailable');

alter table "projects"
  alter column "billable" set data type time_status using (
    case
        when billable then 'billable'::time_status
        else 'nonbillable'::time_status
    end
  );

COMMIT;
