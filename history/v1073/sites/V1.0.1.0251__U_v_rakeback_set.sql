-- auto gen by bruce 2016-09-12 10:43:25
DROP VIEW IF EXISTS v_rakeback_set;
CREATE OR REPLACE VIEW v_rakeback_set AS
  SELECT
    rs.id,
    rs.name,
    rs.create_time,
    rs.status,
    rs.audit_num,
    rs.remark,
    (SELECT count(1) FROM user_player WHERE user_player.rakeback_id = rs.id) AS player_count,
    (SELECT count(1) FROM player_rank WHERE player_rank.rakeback_id = rs.id AND player_rank.status <> '3') AS rank_count
  FROM rakeback_set rs
  WHERE rs.status <> '2';

COMMENT ON VIEW "v_rakeback_set" IS '返水设置视图 - bruce';