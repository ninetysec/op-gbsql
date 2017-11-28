-- auto gen by longer 2015-11-19 11:54:09


SELECT redo_sqls($$
  alter table sys_user add COLUMN login_ip_dict_code CHARACTER VARYING(100); -- 登录IP地区字典代码
  alter table sys_user add COLUMN last_login_ip_dict_code CHARACTER VARYING(100); -- 操作者IP地区字典代码
  alter table sys_user add COLUMN register_ip_dict_code CHARACTER VARYING(100); -- 操作者IP地区字典代码
$$);

COMMENT ON COLUMN sys_user.login_ip_dict_code is '登录IP地区字典代码';
COMMENT ON COLUMN sys_user.last_login_ip_dict_code is '上次登录IP地区字典代码';
COMMENT ON COLUMN sys_user.register_ip_dict_code is '注册IP地区字典代码';
