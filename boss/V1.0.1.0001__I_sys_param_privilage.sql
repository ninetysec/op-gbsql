-- auto gen by longer 2016-02-02 19:05:28

INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)
  SELECT 'setting', 'privilage_pass_time', 'setting.privilage.pass.time', '10', '5', 1, '权限密码设置', null, true, null
  where not exists (select id from sys_param where module='setting' and param_type = 'privilage_pass_time' and param_code = 'setting.privilage.pass.time');
