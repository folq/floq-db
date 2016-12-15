-- Revert floq:blankrank_tables.sql from pg

BEGIN;

DROP TABLE ranked_matchups;
DROP TYPE ranked_matchup_result;
DROP TABLE ranked_games;

COMMIT;
