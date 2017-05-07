-- auto gen by bruce 2016-10-04 14:40:40
drop view if EXISTS v_rakeback_set;
CREATE OR REPLACE VIEW "v_rakeback_set" AS
 SELECT rs.id,
    rs.name,
    rs.create_time,
    rs.status,
    rs.audit_num,
    rs.remark,
    ( SELECT count(1) AS count
           FROM user_player a,sys_user b
          WHERE a.id=b.id and (a.rakeback_id = rs.id)) AS player_count,
    ( SELECT count(1) AS count
           FROM player_rank
          WHERE ((player_rank.rakeback_id = rs.id) AND ((player_rank.status)::text <> '3'::text))) AS rank_count
   FROM rakeback_set rs
  WHERE ((rs.status)::text <> '2'::text);

COMMENT ON VIEW "v_rakeback_set" IS '返水设置视图 - bruce eidt by younger';