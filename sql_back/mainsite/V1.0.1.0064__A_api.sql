-- auto gen by cheery 2015-11-05 07:34:31
--修改api表
DROP VIEW IF EXISTS v_api_i18n;
DROP VIEW IF EXISTS v_game_announcement;

ALTER TABLE "api" DROP COLUMN IF EXISTS "api_name";
ALTER TABLE "game" DROP COLUMN IF EXISTS "category";
ALTER TABLE "game" DROP COLUMN IF EXISTS "cover";
ALTER TABLE "game" DROP COLUMN IF EXISTS "game_name";

select redo_sqls($$
    ALTER TABLE "api" ADD COLUMN "order_num" int4;
    ALTER TABLE "api_i18n" ADD COLUMN "logo1" varchar(128) COLLATE "default";
    ALTER TABLE "api_i18n" ADD COLUMN "logo2" varchar(128) COLLATE "default";
    ALTER TABLE "game" ADD COLUMN "order_num" int4;
    ALTER TABLE "game_i18n" ADD COLUMN "cover" varchar(128) COLLATE "default";
$$);

COMMENT ON COLUMN "api"."order_num" IS '序号';

COMMENT ON COLUMN "api_i18n"."logo1" IS '封面1';

COMMENT ON COLUMN "api_i18n"."logo2" IS '封面2';

COMMENT ON COLUMN "game"."order_num" IS '序号';

COMMENT ON COLUMN "game_i18n"."cover" IS '封面';

CREATE OR REPLACE VIEW "v_game_announcement" AS
  SELECT n.id,
    a.api_id,
    a.release_time,
    n.language,
    n.title,
    n.content,
    '' AS cover,
    a.game_id
  FROM game_announcement a
    LEFT JOIN game_announcement_i18n n ON n.game_announcement_id = a.id
    LEFT JOIN game g ON g.id = a.game_id;

ALTER TABLE "v_game_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_game_announcement" IS '游戏公告视图 --Orange';

--创建api_type
CREATE TABLE IF NOT EXISTS "api_type" (
  "id" int4 NOT NULL,
  "url" varchar(128) COLLATE "default",
  "parameter" varchar(1024) COLLATE "default",
  "order_num" int4,
  CONSTRAINT "api_type_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "api_type" OWNER TO "postgres";

COMMENT ON TABLE "api_type" IS 'api_type-- susu';

COMMENT ON COLUMN "api_type"."id" IS '主键';

COMMENT ON COLUMN "api_type"."url" IS 'url地址';

COMMENT ON COLUMN "api_type"."parameter" IS '参数';

COMMENT ON COLUMN "api_type"."order_num" IS '序号';


--创建api_type_i18n
CREATE TABLE IF NOT EXISTS "api_type_i18n" (
  "id" int4 NOT NULL,
  "api_type_id" int4,
  "name" varchar(100) COLLATE "default",
  "local" char(5) COLLATE "default",
  "cover" varchar(128) COLLATE "default",
  CONSTRAINT "api_type_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "api_type_i18n" OWNER TO "postgres";

COMMENT ON TABLE "api_type_i18n" IS 'api_type_i18n-- susu';

COMMENT ON COLUMN "api_type_i18n"."id" IS '主键';

COMMENT ON COLUMN "api_type_i18n"."api_type_id" IS 'api类型主键';

COMMENT ON COLUMN "api_type_i18n"."name" IS '类型名称';

COMMENT ON COLUMN "api_type_i18n"."local" IS '语言代码';

COMMENT ON COLUMN "api_type_i18n"."cover" IS '封面';

--添加api_type_i18n
CREATE TABLE IF NOT EXISTS "api_type_i18n" (
  "id" int4 NOT NULL,
  "api_type_id" int4,
  "name" varchar(100) COLLATE "default",
  "local" char(5) COLLATE "default",
  "cover" varchar(128) COLLATE "default",
  CONSTRAINT "api_type_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "api_type_i18n" OWNER TO "postgres";

COMMENT ON TABLE "api_type_i18n" IS 'api_type_i18n-- susu';

COMMENT ON COLUMN "api_type_i18n"."id" IS '主键';

COMMENT ON COLUMN "api_type_i18n"."api_type_id" IS 'api类型主键';

COMMENT ON COLUMN "api_type_i18n"."name" IS '类型名称';

COMMENT ON COLUMN "api_type_i18n"."local" IS '语言代码';

COMMENT ON COLUMN "api_type_i18n"."cover" IS '封面';

--添加api_type_relation-
CREATE TABLE IF NOT EXISTS "api_type_relation" (
  "id" int4 NOT NULL,
  "api_id" int4,
  "type" int4,
  CONSTRAINT "api_type_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "api_type_relation" OWNER TO "postgres";

COMMENT ON TABLE "api_type_relation" IS 'site_api_type_relation-- susu';

COMMENT ON COLUMN "api_type_relation"."id" IS '主键';

COMMENT ON COLUMN "api_type_relation"."api_id" IS 'api主键';

COMMENT ON COLUMN "api_type_relation"."type" IS '类别';

