-- auto gen by water 2018-03-09 15:39:00

-- mobile-v3升级开关设置成boss可控
UPDATE sys_param SET  operate = '0'
where module = 'setting' and param_type = 'system_settings' and param_code = 'mobile_upgrade';