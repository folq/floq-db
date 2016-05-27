-- Deploy floq:norwegian_holidays_to_2018 to pg
-- requires: holidays_table

BEGIN;

-- de-facto holidays:
INSERT INTO holidays (date, name) VALUES ('2016-12-24', 'Julaften');
INSERT INTO holidays (date, name) VALUES ('2016-12-31', 'Nyttårsaften');
INSERT INTO holidays (date, name) VALUES ('2017-12-24', 'Julaften');
INSERT INTO holidays (date, name) VALUES ('2017-12-31', 'Nyttårsaften');
INSERT INTO holidays (date, name) VALUES ('2018-12-24', 'Julaften');
INSERT INTO holidays (date, name) VALUES ('2018-12-31', 'Nyttårsaften');

-- “real” holidays
INSERT INTO holidays (date, name) VALUES ('2016-01-01', '1. nyttårsdag');
INSERT INTO holidays (date, name) VALUES ('2016-03-20', 'Palmesøndag');
INSERT INTO holidays (date, name) VALUES ('2016-03-24', 'Skjærtorsdag');
INSERT INTO holidays (date, name) VALUES ('2016-03-25', 'Langfredag');
INSERT INTO holidays (date, name) VALUES ('2016-03-28', '2. påskedag');
INSERT INTO holidays (date, name) VALUES ('2016-05-01', 'Arbeidernes internasjonale kampdag');
INSERT INTO holidays (date, name) VALUES ('2016-05-05', 'Kristi himmelfartsdag');
INSERT INTO holidays (date, name) VALUES ('2016-05-15', '1. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2016-05-16', '2. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2016-05-17', 'Grunnlovsdag');
INSERT INTO holidays (date, name) VALUES ('2016-12-26', '1. juledag');
INSERT INTO holidays (date, name) VALUES ('2016-12-27', '2. juledag');
INSERT INTO holidays (date, name) VALUES ('2017-01-01', '1. nyttårsdag');
INSERT INTO holidays (date, name) VALUES ('2017-04-09', 'Palmesøndag');
INSERT INTO holidays (date, name) VALUES ('2017-04-13', 'Skjærtorsdag');
INSERT INTO holidays (date, name) VALUES ('2017-04-14', 'Langfredag');
INSERT INTO holidays (date, name) VALUES ('2017-04-17', '2. påskedag');
INSERT INTO holidays (date, name) VALUES ('2017-05-01', 'Arbeidernes internasjonale kampdag');
INSERT INTO holidays (date, name) VALUES ('2017-05-17', 'Grunnlovsdag');
INSERT INTO holidays (date, name) VALUES ('2017-05-25', 'Kristi himmelfartsdag');
INSERT INTO holidays (date, name) VALUES ('2017-06-04', '1. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2017-06-05', '2. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2017-12-25', '1. juledag');
INSERT INTO holidays (date, name) VALUES ('2017-12-26', '2. juledag');
INSERT INTO holidays (date, name) VALUES ('2018-01-01', '1. nyttårsdag');
INSERT INTO holidays (date, name) VALUES ('2018-03-25', 'Palmesøndag');
INSERT INTO holidays (date, name) VALUES ('2018-03-29', 'Skjærtorsdag');
INSERT INTO holidays (date, name) VALUES ('2018-03-30', 'Langfredag');
INSERT INTO holidays (date, name) VALUES ('2018-04-02', '2. påskedag');
INSERT INTO holidays (date, name) VALUES ('2018-05-01', 'Arbeidernes internasjonale kampdag');
INSERT INTO holidays (date, name) VALUES ('2018-05-10', 'Kristi himmelfartsdag');
INSERT INTO holidays (date, name) VALUES ('2018-05-17', 'Grunnlovsdag');
INSERT INTO holidays (date, name) VALUES ('2018-05-20', '1. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2018-05-21', '2. pinsedag');
INSERT INTO holidays (date, name) VALUES ('2018-12-25', '1. juledag');
INSERT INTO holidays (date, name) VALUES ('2018-12-26', '2. juledag');

COMMIT;
