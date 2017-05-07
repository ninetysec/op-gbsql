-- auto gen by cherry 2016-07-22 15:13:55
insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)

  SELECT 'notice', 'contact_way_type', '304', null, '微信', NULL, 't'

  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = '304' and dict_type='contact_way_type');