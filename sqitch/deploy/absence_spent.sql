-- Deploy floq:absence_spent to pg

BEGIN;

-- View returning days with time tracked on any timecode in absence_reasons
CREATE VIEW absence_spent AS (
    SELECT employee as employee_id, date, project as reason, SUM(minutes) as minutes
	FROM time_entry t
	WHERE t.project in (
		SELECT id from absence_reasons
	)
	GROUP BY (employee_id, date, project)
	HAVING SUM(minutes) > 0
);

COMMIT;
