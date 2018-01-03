-- auto gen by george 2017-10-26 11:16:17
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'player', 'channel_terminal', 'PC', '1', 'PC端', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='channel_terminal' AND dict_code='1');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'player', 'channel_terminal', 'App', '2', '手机端APP', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='channel_terminal' AND dict_code='2');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'player', 'channel_terminal', 'Mobile', '3', '手机端Web', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='channel_terminal' AND dict_code='3');