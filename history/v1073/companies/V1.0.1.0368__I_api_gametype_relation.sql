-- auto gen by cherry 2017-07-22 14:36:43
INSERT INTO"api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT '22', 'Lottery', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_gametype_relation WHERE api_id=22 and game_type='Lottery');