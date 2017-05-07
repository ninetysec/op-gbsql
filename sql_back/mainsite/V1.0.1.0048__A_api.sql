-- auto gen by cheery 2015-10-23 14:49:44
--修改api表,游戏表
DROP VIEW IF EXISTS v_game_announcement;

select redo_sqls($$
  ALTER TABLE "api" ADD COLUMN "api_name" varchar(64);

  ALTER TABLE "game" ADD COLUMN "category" varchar(64), ADD COLUMN "game_name" varchar(64);

  ALTER TABLE game ADD COLUMN "cover" varchar(128);
$$);

COMMENT ON COLUMN "api"."api_name" IS 'api名称:site_i18n表api_name的key';

COMMENT ON COLUMN "game"."category" IS '类别：site_i18n表的key';

COMMENT ON COLUMN "game"."game_name" IS '游戏名称:取site_i18n表的key';

COMMENT ON COLUMN "game"."cover" IS '游戏封面';

--创建游戏公告视图
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
