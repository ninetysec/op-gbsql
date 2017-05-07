-- auto gen by cheery 2015-11-05 06:06:18
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'transfer_state', 'failure', '3', '转账状态：失败', NULL, 't'
  WHERE 'failure' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'transfer_state');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'transfer_state', 'success', '2', '转账状态：成功', NULL, 't'
  WHERE 'success' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'transfer_state');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'transfer_state', 'pending_confirm', '1', '转账状态：待确认', NULL, 't'
  WHERE 'pending_confirm' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'transfer_state');
