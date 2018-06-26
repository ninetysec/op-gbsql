-- auto gen by steffan 2018-05-22 20:05:57 add by mical
INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT  'api', 'transaction_type', 'transfer_out', '8', '钱包转API', NULL, 't'
  WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='transfer_out') ;
INSERT INTO sys_dict (module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT  'api', 'transaction_type', 'transfer_into', '9', 'API转钱包', NULL, 't'
  WHERE NOT EXISTS (SELECT id FROM sys_dict  WHERE  module='api' and dict_type='transaction_type' and dict_code='transfer_into') ;