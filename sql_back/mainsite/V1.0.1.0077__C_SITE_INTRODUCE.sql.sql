-- auto gen by tom 2015-11-17 15:37:17
-- 站点管理,介绍人管理
CREATE TABLE IF NOT EXISTS "site_introducer" (
"id" int4 NOT NULL,
"site_id" int4 NOT NULL,
"name" varchar(32) COLLATE "default" NOT NULL,
"create_user" int4 NOT NULL,
"create_time" timestamp(6) NOT NULL,
"update_user" int4,
"update_time" timestamp(6),
CONSTRAINT "site_introducer_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_introducer" OWNER TO "postgres";

COMMENT ON TABLE "site_introducer" IS '介绍人--tom';

COMMENT ON COLUMN "site_introducer"."id" IS '主键';

COMMENT ON COLUMN "site_introducer"."site_id" IS '站点ID';

COMMENT ON COLUMN "site_introducer"."name" IS '介绍人姓名';

COMMENT ON COLUMN "site_introducer"."create_user" IS '创建用户ID';

COMMENT ON COLUMN "site_introducer"."create_time" IS '创建时间';

COMMENT ON COLUMN "site_introducer"."update_user" IS '更新用户ID';

COMMENT ON COLUMN "site_introducer"."update_time" IS '更新时间';