CREATE OR REPLACE FUNCTION is_absence_reason(reason text)
        RETURNS boolean AS
$$
BEGIN
  RETURN (    reason = 'FER1000'
           OR reason = 'SYK1001'
           OR reason = 'SYK1002'
           OR reason = 'PER1000'
           OR reason = 'PER1001'
         );
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW absence_reasons
         AS ( SELECT id, name
                FROM projects
               WHERE is_absence_reason(id)
            );
