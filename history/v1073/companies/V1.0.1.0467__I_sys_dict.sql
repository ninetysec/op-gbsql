-- auto gen by marz 2017-11-09 19:19:15
UPDATE sys_dict SET remark = '重结扣款' WHERE module='lottery' and dict_type='transaction_type' AND dict_code = '6';

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '7', '7', '重结派彩', NULL, 't'
where '7' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '8', '8', '待结撤单', NULL, 't'
where '8' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '9', '9', '已结撤销', NULL, 't'
where '9' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');