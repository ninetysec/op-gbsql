-- auto gen by linsen 2018-04-01 20:01:47
-- 修改禁用转账比例为100% by linsne
UPDATE sys_param SET param_value='100', default_value='100' WHERE module='setting' AND param_type='credit' AND param_code='transfer_limit_stop';
