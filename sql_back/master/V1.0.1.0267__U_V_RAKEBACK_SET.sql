-- auto gen by tom 2015-12-17 17:08:40
DROP VIEW IF EXISTS v_rakeback_set;


 CREATE OR REPLACE VIEW "v_rakeback_set" AS
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

ALTER TABLE "v_rakeback_set" OWNER TO "postgres";

COMMENT ON VIEW "v_rakeback_set" IS '代理信息视图－cheery';