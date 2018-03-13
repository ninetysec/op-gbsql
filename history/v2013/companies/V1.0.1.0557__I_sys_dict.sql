-- auto gen by linsen 2018-02-26 09:33:42
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'credit', 'credit_status', '4', '4', '买分充值记录_撤销', NULL, 't'
WHERE '4' not in (SELECT dict_code from sys_dict where module = 'credit' and dict_type = 'credit_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'credit', 'pay_type', '4', '4', '买分支付类型：4-线下充值', NULL, 't'
WHERE '4' not in (SELECT dict_code from sys_dict where module = 'credit' and dict_type = 'pay_type');
