-- auto gen by linsen 2018-04-28 16:56:36

-- 新增活动交易方式字典: 资金类型查询中使用 by steffan

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'transaction_way', 'second_deposit', '29', '次存送', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'transaction_way' and  dict_code='second_deposit');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'transaction_way', 'third_deposit', '30', '三存送', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'transaction_way' and  dict_code='third_deposit');


INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select  'common', 'transaction_way', 'everyday_first_deposit', '31', '每日首存', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type = 'transaction_way' and  dict_code='everyday_first_deposit');