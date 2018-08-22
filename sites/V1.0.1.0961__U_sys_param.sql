-- auto gen by linsen 2018-08-22 15:44:24
-- 修改备注:开启代付出款
UPDATE sys_param SET remark='开启代付出款' WHERE module='fund' AND param_type='withdraw' AND param_code='easy_payment';
