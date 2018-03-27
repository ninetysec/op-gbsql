-- auto gen by george 2018-01-14 17:51:48
--添加站点收藏表by carl
CREATE TABLE IF NOT EXISTS game_collect(
"id" SERIAL4 NOT NULL,
"user_id" int4 NOT NULL,
"api_id" int4 NOT NULL,
"game_id" int4 NOT NULL,
"collect_time" timestamp(6) NOT NULL,
PRIMARY KEY ("id"),
UNIQUE ("user_id", "game_id")
  );
COMMENT ON TABLE "game_collect" IS '游戏收藏表-carl';

COMMENT ON COLUMN "game_collect"."id" IS '主键';

COMMENT ON COLUMN "game_collect"."user_id" IS '玩家id';

COMMENT ON COLUMN "game_collect"."api_id" IS 'API id';

COMMENT ON COLUMN "game_collect"."game_id" IS '游戏id';

COMMENT ON COLUMN "game_collect"."collect_time" IS '收藏时间';