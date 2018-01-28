-- auto gen by water 2018-01-10 21:36:00

--域名access参数缺失
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)
  select 'setting', 'system_settings', 'access_domain', '', null, null, '访问域名设置', null, true, null
  where not exists(
      select id
      from sys_param t
      where module = 'setting' and param_type = 'system_settings' and param_code = 'access_domain'
  );
