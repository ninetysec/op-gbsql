-- auto gen by cheery 2015-11-18 12:19:04
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'status', 'pending_pay', '7', '状态：待支付', NULL, 't'
  WHERE 'pending_pay' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'status', 'over_time', '8', '状态：超时', NULL, 't'
  WHERE 'over_time' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'status', 'deal_audit_fail', '9', '状态:待处理-稽核失败', NULL, 't'
  WHERE 'deal_audit_fail' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');