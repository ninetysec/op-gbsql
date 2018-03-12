-- auto gen by water 2018-03-11 20:50:16

--mobile switch
UPDATE sys_param SET operate = '0'
where module = 'setting' and param_type = 'system_settings' and param_code = 'mobile_upgrade';