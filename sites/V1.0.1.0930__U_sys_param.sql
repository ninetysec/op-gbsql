-- auto gen by linsen 2018-07-28 15:09:34
-- 开启APP启动页

UPDATE sys_param SET param_value='true' WHERE "module"='setting' AND param_type='system_setting' AND param_code='app_start_page';
