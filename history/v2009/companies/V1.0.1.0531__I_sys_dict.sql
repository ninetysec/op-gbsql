-- auto gen by george 2018-01-24 20:33:31
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'game', 'game_type', 'Chess', '7', '棋牌', NULL, 't'
where not EXISTS (SELECT dict_code from sys_dict where MODULE='game' and dict_type='game_type' and dict_code='Chess');