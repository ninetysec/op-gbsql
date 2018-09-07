-- auto gen by linsen 2018-07-18 16:05:38
-- 棋牌包网分享图片 by linsen
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'system_setting', 'chess_share_picture', '', '', '1', '棋牌包网分享图片', NULL, 't', NULL, 'f', '1'
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' and param_type='system_setting' AND param_code='chess_share_picture') ;
