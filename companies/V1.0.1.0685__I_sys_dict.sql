-- auto gen by steffan 2018-09-18 15:05:40

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '84','84', '修改APP启动页开关', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='84');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '85','85', '代付出款账户', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='85');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '86','86', '手续费设置', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='86');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '87','87', '玩家存款', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='87');


INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '95','95', '站点开关启用/禁用', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='95');
