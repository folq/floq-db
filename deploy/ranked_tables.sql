-- Deploy floq:ranked_tables to pg
-- requires employees_table

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE ranked_games (
  id    text NOT NULL DEFAULT (uuid_generate_v4()),
  title text NOT NULL DEFAULT '',
  PRIMARY KEY (id)
);

INSERT INTO ranked_games (title) VALUES ('FIFA 2016'), ('Sjakk');

CREATE TYPE ranked_matchup_result as ENUM ('WIN', 'LOSS', 'TIE');

CREATE TABLE ranked_matchups (
  id       text NOT NULL DEFAULT (uuid_generate_v4()),
  game_id  text NOT NULL REFERENCES ranked_games(id),

  user1_id integer NOT NULL REFERENCES employees(id),
  user2_id integer NOT NULL REFERENCES employees(id),
    CHECK (user1_id != user2_id),

  matchup_result ranked_matchup_result NOT NULL DEFAULT ('TIE'),
  created_at     timestamp             NOT NULL DEFAULT now(),

  PRIMARY KEY (id)
);

COMMIT;
