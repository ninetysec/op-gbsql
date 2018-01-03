-- auto gen by longer 2016-01-26 14:52:47

delete from sys_param where module = 'setting' and param_type = 'securityCode';
delete from sys_param where module = 'setting' and param_type = 'captcha_style';

-- INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active) VALUES ('setting', 'captcha_style', 'default', 'images/captcha/default.jpg', 'images/captcha/default.jpg', 1, '验证码样式', null, true);
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active) VALUES ('setting', 'captcha_style', 'black', 'images/captcha/black.jpg', 'images/captcha/black.jpg', 2, '验证码样式', null, true);
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active) VALUES ('setting', 'captcha_style', 'blue', 'images/captcha/blue.jpg', 'images/captcha/blue.jpg', 3, '验证码样式', null, true);
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active) VALUES ('setting', 'captcha_style', 'gray', 'images/captcha/gray.jpg', 'images/captcha/gray.jpg', 4, '验证码样式', null, true);
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active) VALUES ('setting', 'captcha_style', 'green', 'images/captcha/green.jpg', 'images/captcha/green.jpg', 5, '验证码样式', null, true);

update sys_param set param_type = 'captcha' ,param_code = 'style',param_value = 'default',default_value = 'default'  where module = 'setting' and param_type = 'yzm' and param_code = 'value';
update sys_param set param_type = 'captcha'  where module = 'setting' and param_type = 'yzm' and param_code = 'exclusions';
