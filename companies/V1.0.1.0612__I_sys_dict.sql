-- auto gen by steffan 2018-05-15 11:57:00

-- 玩家注册渠道字典 add by steffan

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'player', 'create_channel', '8', '8', '手机端H5', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type = 'create_channel' and  dict_code='8');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'player', 'create_channel', '12', '12', '手机端ANDROID', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type = 'create_channel' and  dict_code='12');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'player', 'create_channel', '16', '16', '手机端IOS', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type = 'create_channel' and  dict_code='16');