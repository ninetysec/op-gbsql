-- auto gen by linsen 2018-04-09 11:48:26
-- 添加字典:活动大厅 by kobe
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'float_pic_display_in', '6', '6', '活动大厅', NULL, 't'
WHERE '6' NOT IN(SELECT dict_code FROM sys_dict WHERE module ='content' AND dict_type='float_pic_display_in');