-- auto gen by cheery 2015-12-04 10:56:35
--删除用户扩展表重复字段
DROP VIEW IF EXISTS v_sys_site_user;
ALTER TABLE user_extend DROP COLUMN IF EXISTS name;
ALTER TABLE user_extend DROP COLUMN IF EXISTS status;
ALTER TABLE user_extend DROP COLUMN IF EXISTS is_buildin;
ALTER TABLE user_extend DROP COLUMN IF EXISTS time_zone;
ALTER TABLE user_extend DROP COLUMN IF EXISTS currency;
ALTER TABLE user_extend DROP COLUMN IF EXISTS register_time;

COMMENT ON TABLE user_extend IS '用户扩展表--longer';
COMMENT ON COLUMN user_extend.theme_id IS '主题id';
select redo_sqls($$
   ALTER TABLE user_extend ADD CONSTRAINT "user_extend_pkey" PRIMARY KEY ("id");
  $$);


CREATE OR REPLACE VIEW v_sys_site_user AS
  SELECT
    site.id,
    site.name      AS site_name,
    usr.id         AS sys_user_id,
    usr.username,
    usr.subsys_code,
    usr.site_id    AS center_id,
    site.parent_id AS site_parent_id
  FROM sys_site site,
    sys_user usr
  WHERE site.sys_user_id = usr.id;

DROP VIEW IF EXISTS v_sys_user_operators;

--创建运营商视图
CREATE OR REPLACE VIEW v_sys_user_operators AS
  SELECT
    t2.name,
    t3.referrals,
    t1.id,
    t1.username,
    t1.birthday,
    t1.sex,
    t1.create_time,
    t1.last_login_ip,
    t1.last_login_time,
    t1.last_login_ip_dict_code,
    t1.constellation,
    t1.memo,
    t1.nickname,
    t1.status
  FROM sys_user t1
    LEFT JOIN sys_site t2 ON t1.id = t2.sys_user_id
    LEFT JOIN user_extend t3 ON t1.id = t3.id
  WHERE t1.user_type = '1';

COMMENT ON VIEW v_sys_user_operators IS '运营商视图--cherry';