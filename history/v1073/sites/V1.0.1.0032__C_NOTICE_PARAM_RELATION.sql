-- auto gen by tom 2016-03-03 15:03:17
CREATE TABLE IF NOT EXISTS "notice_param_relation" (
id SERIAL4, -- 主键
"param_code" varchar(50) COLLATE "default" NOT NULL,
"event_type" varchar(32) COLLATE "default" NOT NULL,
"order" int2,
CONSTRAINT "notice_param_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_param_relation" OWNER TO "postgres";

COMMENT ON TABLE "notice_param_relation" IS '信息模板内容参数表';

COMMENT ON COLUMN "notice_param_relation"."param_code" IS '参数占位符';

COMMENT ON COLUMN "notice_param_relation"."event_type" IS '对应notice_tmpl的event_type(如果通用值为:common)';

COMMENT ON COLUMN "notice_param_relation"."order" IS '排序';