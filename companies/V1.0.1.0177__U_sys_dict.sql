-- auto gen by cherry 2016-09-17 14:43:16
insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'operation', 'activity_state', 'remove', 5, '已下架', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'remove' and dict_type='activity_state');