-- auto gen by george 2017-12-11 14:56:33
DROP VIEW IF EXISTS v_sys_role;

CREATE OR REPLACE VIEW "v_sys_role" AS
 SELECT sr.id,
    sr.name,
    sr.site_id,
    sr.subsys_code,
    sr.built_in,
    sr.create_user,
    COALESCE(user_role.user_count, (0)::bigint) AS user_count
   FROM (sys_role sr
     LEFT JOIN ( SELECT sys_user_role.role_id,
            count(1) AS user_count
           FROM sys_user_role
          GROUP BY sys_user_role.role_id) user_role ON ((user_role.role_id = sr.id)));

COMMENT ON VIEW "v_sys_role" IS '角色视图 -edit by leo';