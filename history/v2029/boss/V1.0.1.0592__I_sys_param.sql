-- auto gen by linsen 2018-08-07 16:26:54
--棋牌包网公共图标版本
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT  'setting', 'chess_setting', 'chess_icon_public_version', '1', NULL, '1', '棋牌包网公共图标版本', NULL, 't', 0, 'f', NULL
WHERE NOT EXISTS(SELECT ID FROM sys_param WHERE module='setting' AND param_type='chess_setting'  AND param_code='chess_icon_public_version');