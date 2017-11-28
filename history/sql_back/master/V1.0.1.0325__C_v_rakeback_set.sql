-- auto gen by cherry 2016-01-12 14:55:47
--- 修改优惠稽核字段
DROP VIEW IF EXISTS v_rakeback_set;
ALTER TABLE "rakeback_set" ALTER COLUMN "audit_num" TYPE numeric(20,2);

DROP INDEX if EXISTS "fk_rakeback_set_create_user_id";

CREATE INDEX "fk_rakeback_set_create_user_id" ON "rakeback_set" USING btree ("create_user_id" "pg_catalog"."int4_ops");

CREATE OR REPLACE VIEW v_rakeback_set as
 SELECT rs.id,
    rs.name,
    rs.create_time,
    rs.status,
    rs.audit_num,
    rs.remark,
    ( SELECT count(1) AS count
           FROM user_player
          WHERE (user_player.rakeback_id = rs.id)) AS player_count,
    COALESCE(uar.count, (0)::bigint) AS agent_count
   FROM (rakeback_set rs
     LEFT JOIN ( SELECT count(1) AS count,
            user_agent_rakeback.rakeback_id
           FROM user_agent_rakeback
          WHERE (user_agent_rakeback.user_id IN ( SELECT s_u.id
                   FROM (sys_user s_u
                     JOIN user_agent ua ON ((s_u.id = ua.id)))
                  WHERE (((s_u.owner_id IS NOT NULL) AND ((s_u.user_type)::text = '23'::text)) AND ((s_u.status)::text < '5'::text))))
          GROUP BY user_agent_rakeback.rakeback_id) uar ON ((uar.rakeback_id = rs.id)))
  WHERE ((rs.status)::text <> '2'::text);
COMMENT ON VIEW "v_rakeback_set" IS '返水方案视图 - jeff';

-- 创建角色视图
CREATE OR REPLACE VIEW v_sys_role AS SELECT
  ROLE . ID,
  ROLE . NAME,
  ROLE .subsys_code,
  ROLE .built_in,
  COALESCE (user_role.user_count, 0)  user_count
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