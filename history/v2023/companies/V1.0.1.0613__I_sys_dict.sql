-- auto gen by steffan 2018-05-15 14:42:11
-- terminal_type add by steffan
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'terminal_type', '1', '1', 'pc端', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'terminal_type' and  dict_code='1');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'terminal_type', '2', '2', '手机', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'terminal_type' and  dict_code='2');


INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'terminal_type', '8', '8', '手机端H5', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'terminal_type' and  dict_code='8');


INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'terminal_type', '12', '12', '手机端ANDROID', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'terminal_type' and  dict_code='12');


INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'terminal_type', '16', '16', '手机端IOS', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'terminal_type' and  dict_code='16');

