-- auto gen by george 2018-01-14 09:22:36
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '1', '1', '公司入款', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '1');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '2', '2', '网银', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '2');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '3', '3', '微信', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '3');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '4', '4', '支付宝', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '4');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '5', '5', 'QQ钱包', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '5');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '6', '6', '京东钱包', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '6');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '7', '7', '百度钱包', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '7');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'account_type', '8', '8', '银联扫码', NULL, 't'
WHERE NOT EXISTS (select id from sys_dict where module = 'content' AND dict_type='account_type' AND dict_code = '8');