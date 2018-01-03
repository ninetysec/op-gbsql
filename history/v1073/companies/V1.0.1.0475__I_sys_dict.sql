-- auto gen by george 2017-11-17 15:45:46
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'credit', 'pay_type', '3', '3', '买分支付类型：3-清算余额', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='pay_type' AND dict_code='3');