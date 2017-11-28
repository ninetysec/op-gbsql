-- auto gen by cheery 2015-10-23 14:43:58
--添加游戏公告表,游戏公告国际化表
CREATE TABLE IF NOT EXISTS "game_announcement" (
  "id" SERIAL4 NOT NULL,
  "api_id" int4,
  "game_id" int4,
  "release_time" timestamp(6),
  CONSTRAINT "game_announcement_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_announcement" OWNER TO "postgres";

COMMENT ON TABLE "game_announcement" IS '游戏公告表-- suyj';
COMMENT ON COLUMN "game_announcement"."id" IS '主键id';
COMMENT ON COLUMN "game_announcement"."api_id" IS 'API主键';
COMMENT ON COLUMN "game_announcement"."game_id" IS '游戏ID';
COMMENT ON COLUMN "game_announcement"."release_time" IS '发布时间';

CREATE TABLE IF NOT EXISTS "game_announcement_i18n" (
  "id" SERIAL4 NOT NULL,
  "game_announcement_id" int4,
  "language" varchar(32),
  "title" varchar(100) COLLATE "default",
  "content" varchar(2000) COLLATE "default",
  CONSTRAINT "game_announcement_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_announcement_i18n" OWNER TO "postgres";

COMMENT ON TABLE "game_announcement_i18n" IS '游戏公告国际化表--suyj';

COMMENT ON COLUMN "game_announcement_i18n"."id" IS '主键id';
COMMENT ON COLUMN "game_announcement_i18n"."game_announcement_id" IS '游戏公告表ID';
COMMENT ON COLUMN "game_announcement_i18n"."language" IS '语言版本(site_language)';
COMMENT ON COLUMN "game_announcement_i18n"."title" IS '标题';
COMMENT ON COLUMN "game_announcement_i18n"."content" IS '内容';