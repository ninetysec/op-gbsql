-- auto gen by tom 2015-11-20 15:59:19

DROP TABLE IF EXISTS site_introducer;
CREATE TABLE IF NOT EXISTS "site_introducer" (
"id" SERIAL4 PRIMARY KEY NOT NULL,
"site_id" int4 NOT NULL,
"name" varchar(32) COLLATE "default" NOT NULL,
"create_user" int4 NOT NULL,
"create_time" timestamp(6) NOT NULL,
"update_user" int4,
"update_time" timestamp(6)
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

