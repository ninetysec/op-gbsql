-- auto gen by marz 2017-10-30 22:01:09
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '5', '5', '返点', NULL, 't'
where '5' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '6', '6', '重结', NULL, 't'
where '6' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '7', '7', '待结撤单', NULL, 't'
where '7' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '8', '8', '已结撤销', NULL, 't'
where '8' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');