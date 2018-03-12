-- auto gen by linsen 2018-03-12 09:16:37

-- BC转账类型 by zain
INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'BETPLACED', '1', '下注', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='BETPLACED') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'ACCEPTED', '2', '接收', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='ACCEPTED') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'RETURNED', '3', '退回', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='RETURNED') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'WIN', '4', '赢', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='WIN') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'LOST', '5', '输', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='LOST') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'CASHEDOUT', '6', '兑现', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='CASHEDOUT') ;

INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
SELECT  'api', 'transaction_type', 'ROLLBACK', '7', '撤销', NULL, 't'
 WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='ROLLBACK') ;

