-- auto gen by marz 2017-12-28 22:02:06
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'log', 'log_type', '41', '41', '赔率修改', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='log' AND dict_type='log_type' AND dict_code='41');
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'log', 'log_type', '42', '42', '限额修改', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='log' AND dict_type='log_type' AND dict_code='42');