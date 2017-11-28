-- auto gen by cherry 2017-01-07 16:35:17
select redo_sqls($$
       ALTER TABLE sys_user ADD COLUMN authentication_key VARCHAR(64);
$$);
COMMENT ON COLUMN sys_user.authentication_key is '动态密码';