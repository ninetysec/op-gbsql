-- auto gen by cheery 2015-10-23 16:47:05
DROP VIEW IF EXISTS v_game_announcement;

CREATE OR REPLACE VIEW "v_game_announcement" AS
  SELECT a.id,
    a.api_id,
    a.release_time,
    n.language,
    n.title,
    n.content,
    g.cover,
    a.game_id
  FROM game_announcement a
    LEFT JOIN game_announcement_i18n n ON n.game_announcement_id = a.id
    LEFT JOIN game g ON g.id = a.game_id ;

ALTER TABLE "v_game_announcement" OWNER TO "postgres";

COMMENT ON VIEW v_game_announcement  IS '游戏公告视图 --Orange';
