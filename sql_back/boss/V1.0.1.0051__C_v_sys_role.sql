-- auto gen by cherry 2016-01-12 15:21:12
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

update sys_resource  set name='API管理' where id=204;