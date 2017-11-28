-- auto gen by longer 2015-11-24 10:13:11


SELECT redo_sqls($$
  alter TABLE sys_user add COLUMN login_error_times  int4;
  alter TABLE sys_user_protection add COLUMN error_times  int4;
  alter TABLE sys_user_protection add COLUMN last_operate_time timestamp WITHOUT TIME ZONE;
$$);

COMMENT ON COLUMN sys_user.login_error_times is '登录错误次数';
COMMENT ON COLUMN sys_user_protection.error_times is '错误次数';
COMMENT ON COLUMN sys_user_protection.last_operate_time is '最后操作时间'