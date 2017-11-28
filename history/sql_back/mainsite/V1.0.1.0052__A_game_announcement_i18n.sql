-- auto gen by cheery 2015-10-26 10:01:31
---删除is_read字段
DROP VIEW IF EXISTS v_game_announcement;

ALTER TABLE game_announcement_i18n DROP COLUMN IF EXISTS is_read;

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
    LEFT JOIN game g ON g.id = a.game_id;

ALTER TABLE "v_game_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_game_announcement" IS '游戏公告视图 --Orange';