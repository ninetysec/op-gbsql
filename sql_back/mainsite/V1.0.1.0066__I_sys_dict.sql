-- auto gen by cheery 2015-11-06 15:36:07
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'favorable_source', 'recharge_favorable', '1', '优惠来源:玩家存款', NULL, 't'
  WHERE 'recharge_favorable' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'favorable_source');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'favorable_source', 'activity_favorable', '2', '优惠来源：活动优惠', NULL, 't'
  WHERE 'activity_favorable' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'favorable_source');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'favorable_source', 'artificial_favorable', '3', '优惠来源：手动存款优惠', NULL, 't'
  WHERE 'artificial_favorable' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'favorable_source');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'fund', 'favorable_source', 'backwater_favorable', '4', '优惠来源：返水优惠', NULL, 't'
  WHERE 'backwater_favorable' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'favorable_source');
