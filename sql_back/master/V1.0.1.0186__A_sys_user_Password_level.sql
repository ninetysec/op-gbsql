-- auto gen by longer 2015-11-13 17:04:13
SELECT redo_sqls($$
  ALTER TABLE sys_user add COLUMN password_level CHARACTER VARYING(2);
$$);
COMMENT ON COLUMN sys_user.password_level is '密码级别:高 30, 中,20 低,10';