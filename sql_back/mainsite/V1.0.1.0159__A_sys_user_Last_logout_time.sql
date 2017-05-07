-- auto gen by longer 2015-12-16 14:33:44
SELECT redo_sqls($$
    alter TABLE sys_user add COLUMN last_logout_time TIMESTAMP(6) WITHOUT TIME ZONE;
$$);
COMMENT ON COLUMN sys_user.last_login_time IS '上次登录时间';
COMMENT ON COLUMN sys_user.last_logout_time IS '上次退出时间';