-- auto gen by linsen 2018-08-30 16:29:27
-- 添加吉林银行和青岛银行
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT   'common', 'bankname', 'jlbank', '52', '吉林银行', NULL, 't'
WHERE NOT EXISTS (SELECT id FROM sys_dict WHERE module='common' and dict_type ='bankname' AND dict_code='jlbank');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT   'common', 'bankname', 'qdbank', '53', '青岛银行', NULL, 't'
WHERE NOT EXISTS (SELECT id FROM sys_dict WHERE module='common' and dict_type ='bankname' AND dict_code='qdbank');
