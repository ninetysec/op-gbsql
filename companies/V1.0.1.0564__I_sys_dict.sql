-- auto gen by linsen 2018-03-01 16:53:11
--字典表:出款状态
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'fund', 'withdraw_check_status', 'payment_success', '1', '出款成功', NULL, 't'
WHERE 'payment_success' not in(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='withdraw_check_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'fund', 'withdraw_check_status', 'payment_processing', '2', '出款处理中', NULL, 't'
WHERE 'payment_processing' not in(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='withdraw_check_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'fund', 'withdraw_check_status', 'payment_fail', '3', '出款失败', NULL, 't'
WHERE 'payment_fail' not in(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='withdraw_check_status');