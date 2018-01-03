-- auto gen by tom 2015-11-25 11:19:10

CREATE TABLE IF NOT EXISTS "site_template" (
"id" serial4 NOT NULL,
"code" varchar(32) COLLATE "default" NOT NULL,
"fee_type" varchar(1) COLLATE "default",
"pixels" varchar(10) COLLATE "default",
"terminal" varchar(2) COLLATE "default",
"description" varchar(100) COLLATE "default",
"price" float4,
CONSTRAINT "site_template_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_template" OWNER TO "postgres";

COMMENT ON TABLE "site_template" IS '站点模板--tom';

COMMENT ON COLUMN "site_template"."id" IS '主键';

COMMENT ON COLUMN "site_template"."code" IS '模板code,使用模板code获取图片路径';

COMMENT ON COLUMN "site_template"."fee_type" IS '1:免费模板;2:收费模板';

COMMENT ON COLUMN "site_template"."pixels" IS '像素';

COMMENT ON COLUMN "site_template"."terminal" IS '终端类型 1:宽屏';

COMMENT ON COLUMN "site_template"."description" IS '描述';

COMMENT ON COLUMN "site_template"."price" IS '价格';