-- auto gen by linsen 2018-04-24 12:17:53
-- 删除新增活动类型字典_站点不需要活动大厅才执行 by steffan

delete FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='everyday_first_deposit';

delete FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='third_deposit';

delete FROM sys_dict where module='common' and dict_type = 'activity_type' and  dict_code='second_deposit';