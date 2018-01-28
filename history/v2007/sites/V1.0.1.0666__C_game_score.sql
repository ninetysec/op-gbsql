-- auto gen by george 2018-01-14 17:56:43
--添加站点积分表by carl
CREATE TABLE IF NOT EXISTS game_score(
"id" SERIAL4 NOT NULL,
"user_id" int4 NOT NULL,
"game_id" int4 NOT NULL,
"score_time" timestamp(6) NOT NULL,
"score" numeric(20,1) NOT NULL,
PRIMARY KEY ("id")
  );

COMMENT ON TABLE "game_score" IS '游戏积分表-carl';

COMMENT ON COLUMN "game_score"."id" IS '主键';

COMMENT ON COLUMN "game_score"."user_id" IS '玩家id';

COMMENT ON COLUMN "game_score"."game_id" IS '游戏id';

COMMENT ON COLUMN "game_score"."score_time" IS '积分时间';

COMMENT ON COLUMN "game_score"."score" IS '积分';
