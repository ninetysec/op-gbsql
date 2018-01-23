-- auto gen by george 2018-01-19 15:35:56

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT  '6', 'Fish', '', ''
where NOT EXISTS (select id from api_gametype_relation where api_id=6 and game_type='Fish');--PT

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT  '10', 'Fish', '', ''
where NOT EXISTS (select id from api_gametype_relation where api_id=10 and game_type='Fish');--BB

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT  '31', 'Fish', '', ''
where NOT EXISTS (select id from api_gametype_relation where api_id=31 and game_type='Fish');--GNS

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT  '35', 'Fish', '', ''
where NOT EXISTS (select id from api_gametype_relation where api_id=35 and game_type='Fish');--MW