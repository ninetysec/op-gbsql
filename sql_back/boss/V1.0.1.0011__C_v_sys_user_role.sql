-- auto gen by kevice 2015-10-13 20:27:55

-- 添加遗漏的nation字段
DROP VIEW IF EXISTS v_sys_user_role;
CREATE OR REPLACE VIEW v_sys_user_role AS
 SELECT u.id,
    u.id AS user_id,
    u.username,
    u.user_type,
    u.default_locale,
    u.subsys_code,
    u.site_id,
    u.nation,
    r.id AS role_id,
    r.name AS role_name,
    r.code AS role_code
   FROM sys_user u
     LEFT JOIN sys_user_role ur ON u.id = ur.user_id
     LEFT JOIN sys_role r ON ur.role_id = r.id;

ALTER TABLE v_sys_user_role
  OWNER TO postgres;
COMMENT ON VIEW v_sys_user_role
  IS '用户角色视图实体 -- Kevice';