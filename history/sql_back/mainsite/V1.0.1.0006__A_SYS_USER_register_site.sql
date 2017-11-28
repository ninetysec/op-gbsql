-- auto gen by longer 2015-09-07 20:42:25

-- 注册网站地址
select redo_sqls($$
  alter TABLE sys_user add COLUMN register_site CHARACTER VARYING(256);
$$);

COMMENT ON COLUMN sys_user.register_site IS '注册网站地址';
