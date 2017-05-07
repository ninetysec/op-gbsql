-- auto gen by cherry 2016-01-12 15:16:39
------修改联系人名称长度为32 开始2016-01-08 15：05 cogo--------
DROP VIEW IF EXISTS v_site_contacts;

ALTER TABLE site_contacts ALTER COLUMN "name" TYPE varchar(32) COLLATE "default";

CREATE OR REPLACE VIEW v_site_contacts AS
 SELECT a.id,
    a.site_id,
    a.name AS name,
    a.mail,
    a.phone,
    a.position_id,
    a.sex,
    a.create_time,
    a.create_user,
    b.name AS position_name
   FROM (site_contacts a
     LEFT JOIN site_contacts_position b ON ((a.position_id = b.id)));

ALTER TABLE v_site_contacts OWNER TO "postgres";

COMMENT ON VIEW v_site_contacts IS '系统联系人视图-lorne';
------修改联系人名称长度为32 结束--------


-- 创建角色视图
CREATE OR REPLACE VIEW v_sys_role AS SELECT
  ROLE . ID,
  ROLE . NAME,
  ROLE .subsys_code,
  ROLE .built_in,
  COALESCE (user_role.user_count, 0) user_count
FROM
  sys_role ROLE
LEFT JOIN (
  SELECT
    role_id,
    COUNT (1) user_count
  FROM
    sys_user_role
  GROUP BY
    role_id
) user_role ON user_role.role_id = "role". ID;
COMMENT ON VIEW "v_sys_role" IS '角色视图 - jeff';