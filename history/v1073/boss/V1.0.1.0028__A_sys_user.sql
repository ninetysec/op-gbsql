-- auto gen by admin 2016-04-19 21:08:24
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN secpwd_freeze_start_time timestamp without time zone;
ALTER TABLE sys_user ADD COLUMN secpwd_freeze_end_time timestamp without time zone;
ALTER TABLE sys_user ADD COLUMN secpwd_error_times integer;
$$);

COMMENT ON COLUMN sys_user.secpwd_freeze_start_time IS '安全密码冻结开始时间';
COMMENT ON COLUMN sys_user.secpwd_freeze_end_time IS '安全密码冻结结束时间';
COMMENT ON COLUMN sys_user.secpwd_error_times IS '安全密码输错次数';