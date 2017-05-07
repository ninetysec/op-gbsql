-- auto gen by cheery 2015-11-05 07:09:57
--修改api字段
ALTER TABLE "site_api" DROP COLUMN IF EXISTS "api_name";

SELECT redo_sqls($$
    ALTER TABLE "site_api" ADD COLUMN "order_num" int4;
$$);

COMMENT ON COLUMN "site_api"."order_num" IS '序号';


--创建site_game-i18n表
CREATE TABLE IF NOT EXISTS "site_game_i18n" (
  "id"      INT4 NOT NULL,
  "game_id" INT4,
  "name"    VARCHAR(32) COLLATE "default",
  "local"   CHAR(5) COLLATE "default",
  "cover"   VARCHAR(128) COLLATE "default",
  CONSTRAINT "site_game_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS =FALSE
);

ALTER TABLE "site_game_i18n" OWNER TO "postgres";

COMMENT ON TABLE "site_game_i18n" IS 'site_game_i18n-- susu';

COMMENT ON COLUMN "site_game_i18n"."id" IS '主键';

COMMENT ON COLUMN "site_game_i18n"."game_id" IS '游戏id';

COMMENT ON COLUMN "site_game_i18n"."name" IS '游戏名称';

COMMENT ON COLUMN "site_game_i18n"."local" IS '语言代码';

COMMENT ON COLUMN "site_game_i18n"."cover" IS '封面';


--删除site_game字段

ALTER TABLE "site_game" DROP COLUMN IF EXISTS "category";
ALTER TABLE "site_game" DROP COLUMN IF EXISTS "cover";
ALTER TABLE "site_game" DROP COLUMN IF EXISTS "game_name";

SELECT redo_sqls($$
    ALTER TABLE "site_game" ADD COLUMN "order_num" int4;
$$);

COMMENT ON COLUMN "site_game"."order_num" IS '序号';

--创建v_site_api_type视图
CREATE OR REPLACE VIEW v_site_api_type AS
  SELECT
    t.id,
    (SELECT count(1) AS apicount
     FROM site_api_type_relation a
     WHERE a.type = t.id) AS api_count,
    0                     AS player_count,
    t.order_num
  FROM site_api_type t;
