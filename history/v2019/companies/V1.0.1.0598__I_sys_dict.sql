-- auto gen by linsen 2018-04-16 09:08:01
-- 增加活动类型字典，add by steffan
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'activity_type', 'second_deposit', '10', '次存送', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='second_deposit');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'activity_type', 'third_deposit', '11', '三存送', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='third_deposit');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'activity_type', 'everyday_first_deposit', '12', '每日首存', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='everyday_first_deposit');

