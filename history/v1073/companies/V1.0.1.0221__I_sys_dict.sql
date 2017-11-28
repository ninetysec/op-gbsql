-- auto gen by cherry 2016-11-26 20:00:05
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT  'content', 'pay_account_type', '1', '1', '公司入款', NULL, 't'
WHERE '1' not in(SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='pay_account_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT  'content', 'pay_account_type', '2', '2', '线上支付', NULL, 't'
 WHERE '2' not in(SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='pay_account_type' );

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT  'content', 'pay_account_type', '4', '4', '支付宝', NULL, 't'
WHERE '4' not in(SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='pay_account_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT  'content', 'pay_account_type', '3', '3', '微信支付', NULL, 't'
WHERE '3' not in(SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='pay_account_type');