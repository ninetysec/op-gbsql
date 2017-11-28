-- auto gen by cherry 2017-09-14 10:27:20
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'credit', 'credit_status', '1', '1', '买分充值记录_处理中', NULL, 't' WHERE  NOT EXISTS (SELECT * FROM sys_dict WHERE dict_type='credit_status' and dict_code='1');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'credit', 'credit_status', '2', '2', '买分充值记录_成功', NULL, 't' WHERE  NOT EXISTS (SELECT * FROM sys_dict WHERE dict_type='credit_status' and dict_code='2');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'credit', 'credit_status', '3', '3', '买分充值记录_失败', NULL, 't' WHERE  NOT EXISTS (SELECT * FROM sys_dict WHERE dict_type='credit_status' and dict_code='3');
