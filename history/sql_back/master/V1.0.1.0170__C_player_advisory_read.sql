-- auto gen by cheery 2015-11-05 07:03:10
--创建player_advisory_read表
CREATE TABLE IF NOT EXISTS "player_advisory_read" (
  "id" SERIAL4 NOT NULL,
  "player_advisory_id" int4,
  "user_id" int4,
  CONSTRAINT "player_advisory_read_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "player_advisory_read" OWNER TO "postgres";

COMMENT ON TABLE "player_advisory_read" IS '玩家咨询已读表-- susu';

COMMENT ON COLUMN "player_advisory_read"."id" IS '主键';

COMMENT ON COLUMN "player_advisory_read"."player_advisory_id" IS '玩家咨询信息ID';

COMMENT ON COLUMN "player_advisory_read"."user_id" IS '玩家ID';

--创建site_api_i18n表
CREATE TABLE IF NOT EXISTS "site_api_i18n" (
  "id" int4 NOT NULL,
  "api_id" int4,
  "name" varchar(32) COLLATE "default",
  "local" char(5) COLLATE "default",
  "logo1" varchar(128) COLLATE "default",
  "logo2" varchar(128) COLLATE "default",
  CONSTRAINT "site_api_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_api_i18n" OWNER TO "postgres";

COMMENT ON TABLE "site_api_i18n" IS 'site_api_i18n表-- susu';

COMMENT ON COLUMN "site_api_i18n"."id" IS '主键';

COMMENT ON COLUMN "site_api_i18n"."api_id" IS 'api主键';

COMMENT ON COLUMN "site_api_i18n"."name" IS '名称';

COMMENT ON COLUMN "site_api_i18n"."local" IS '语言代码';

COMMENT ON COLUMN "site_api_i18n"."logo1" IS '封面1';

COMMENT ON COLUMN "site_api_i18n"."logo2" IS '封面2';

--添加site_api_type
CREATE TABLE IF NOT EXISTS "site_api_type" (
  "id" int4 NOT NULL,
  "url" varchar(128) COLLATE "default",
  "parameter" varchar(1024) COLLATE "default",
  "order_num" int4,
  CONSTRAINT "site_api_type_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_api_type" OWNER TO "postgres";

COMMENT ON TABLE "site_api_type" IS 'site_api_type-- susu';

COMMENT ON COLUMN "site_api_type"."id" IS '主键';

COMMENT ON COLUMN "site_api_type"."url" IS 'url地址';

COMMENT ON COLUMN "site_api_type"."parameter" IS '参数';

COMMENT ON COLUMN "site_api_type"."order_num" IS '序号';


--添加site_api_type_i18n
CREATE TABLE IF NOT EXISTS "site_api_type_i18n" (
  "id" int4 NOT NULL,
  "api_type_id" int4,
  "name" varchar(100) COLLATE "default",
  "local" char(5) COLLATE "default",
  "cover" varchar(128) COLLATE "default",
  CONSTRAINT "site_api_type_i18n_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_api_type_i18n" OWNER TO "postgres";

COMMENT ON TABLE "site_api_type_i18n" IS 'site_api_type_i18n-- susu';

COMMENT ON COLUMN "site_api_type_i18n"."id" IS '主键';

COMMENT ON COLUMN "site_api_type_i18n"."api_type_id" IS 'api类型主键';

COMMENT ON COLUMN "site_api_type_i18n"."name" IS '类型名称';

COMMENT ON COLUMN "site_api_type_i18n"."local" IS '语言代码';

COMMENT ON COLUMN "site_api_type_i18n"."cover" IS '封面';


--添加site_api_type_relation
CREATE TABLE IF NOT EXISTS "site_api_type_relation" (
  "id" int4 NOT NULL,
  "api_id" int4,
  "type" int4,
  CONSTRAINT "site_api_type_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_api_type_relation" OWNER TO "postgres";

COMMENT ON TABLE "site_api_type_relation" IS 'site_api_type_relation-- susu';

COMMENT ON COLUMN "site_api_type_relation"."id" IS '主键';

COMMENT ON COLUMN "site_api_type_relation"."api_id" IS 'api主键';

COMMENT ON COLUMN "site_api_type_relation"."type" IS '类别';