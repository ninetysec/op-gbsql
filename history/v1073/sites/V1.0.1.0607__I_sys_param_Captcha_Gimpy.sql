-- auto gen by water 2017-11-21 16:08:46

INSERT INTO sys_param ( module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)
SELECT 'setting', 'captcha', 'gimpy', '', 'NoGimpy', 0, '验证码清晰化', null, true, null
where not exists(
  SELECT id from sys_param where module = 'setting' and param_type = 'captcha' and param_code = 'gimpy'
);