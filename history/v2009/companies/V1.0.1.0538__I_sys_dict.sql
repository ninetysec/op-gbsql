-- auto gen by george 2018-01-28 09:44:47
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'pay', 'log_analyze', 'pay调用完成', '1', '描述：pay调用完成', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='log_analyze' AND dict_code='pay调用完成');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'pay', 'log_analyze', 'payPageCallBack调用完成', '2', '描述：payPageCallBack调用完成', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='log_analyze' AND dict_code='payPageCallBack调用完成');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'pay', 'log_analyze', 'payServerCallBack调用完成', '3', '描述：payServerCallBack调用完成', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='log_analyze' AND dict_code='payServerCallBack调用完成');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'pay', 'log_analyze', 'payQueryOrder调用完成', '4', '描述：payQueryOrder调用完成', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='log_analyze' AND dict_code='payQueryOrder调用完成');