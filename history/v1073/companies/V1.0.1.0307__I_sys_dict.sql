-- auto gen by cherry 2017-06-17 10:03:48
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'activity_type', 'money', '9', '红包', NULL, 't' where 'money' not in (SELECT dict_code from sys_dict where MODULE='common' and dict_type='activity_type')