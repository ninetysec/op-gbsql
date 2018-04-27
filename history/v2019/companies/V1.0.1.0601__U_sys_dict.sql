-- auto gen by linsen 2018-04-23 20:44:26
-- 更新字典表remark by kobe
UPDATE sys_dict SET remark='一周' WHERE (module='operation' AND dict_type='claim_period' AND dict_code='NaturalWeek');
UPDATE sys_dict SET remark='一日' WHERE (module='operation' AND dict_type='claim_period' AND dict_code='NaturalDay');
UPDATE sys_dict SET remark='一月' WHERE (module='operation' AND dict_type='claim_period' AND dict_code='NaturalMonth');
