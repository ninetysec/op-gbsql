-- auto gen by cherry 2017-09-11 15:09:52
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'LiveDealer', '1', '真人', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='LiveDealer');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'Casino', '2', '电子', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='Casino');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'Sportsbook', '3', '体育', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='Sportsbook');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'Lottery', '4', '彩票', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='Lottery');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'Fish', '5', '捕鱼', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='Fish');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'SixLottery', '6', '六合彩', NULL, 't' where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='SixLottery');


INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter") SELECT 9, 'Fish', NULL, NULL WHERE NOT EXISTS (SELECT api_id from api_gametype_relation where api_id=9 and game_type='Fish');
INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter") SELECT 22, 'SixLottery', NULL, NULL WHERE  NOT EXISTS (SELECT api_id from api_gametype_relation where api_id=22 and game_type='SixLottery');

update game set game_type = 'Fish' where id=90013;
update game set game_type = 'SixLottery' where id= 220003;

update site_game set game_type = 'Fish' where game_id=90013;
update site_game set game_type = 'SixLottery' where game_id= 220003;


