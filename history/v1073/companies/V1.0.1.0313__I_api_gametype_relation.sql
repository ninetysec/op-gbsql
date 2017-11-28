-- auto gen by cherry 2017-06-21 17:10:43
INSERT INTO"api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT '23', 'Sportsbook', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_gametype_relation WHERE api_id=23 and game_type='Sportsbook');

INSERT INTO"api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT '24', 'LiveDealer', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_gametype_relation WHERE api_id=24 and game_type='LiveDealer');