-- auto gen by cheery 2015-12-23 15:20:30
CREATE TABLE IF NOT EXISTS "notice_tmpl" (
"id" SERIAL4 NOT NULL,
"tmpl_type" varchar(6) COLLATE "default" NOT NULL,
"event_type" varchar(32) COLLATE "default" NOT NULL,
"publish_method" varchar(16) COLLATE "default" NOT NULL,
"group_code" varchar(32) COLLATE "default",
"active" bool DEFAULT false NOT NULL,
"locale" varchar(5) COLLATE "default" NOT NULL,
"title" varchar(128) COLLATE "default",
"content" text COLLATE "default",
"default_active" bool DEFAULT false NOT NULL,
"default_title" varchar(128) COLLATE "default",
"default_content" text COLLATE "default",
"create_time" timestamp(6) NOT NULL,
"create_user" int4 NOT NULL,
"update_time" timestamp(6),
"update_user" int4,
"built_in" bool DEFAULT false NOT NULL,
CONSTRAINT "pk_notice_tmpl" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_tmpl" OWNER TO "postgres";

COMMENT ON TABLE "notice_tmpl" IS '通知模板 -- Kevice';

COMMENT ON COLUMN "notice_tmpl"."id" IS '主键';

COMMENT ON COLUMN "notice_tmpl"."tmpl_type" IS '模板类型代码，字典类型tmpl_type(notice模块)';

COMMENT ON COLUMN "notice_tmpl"."event_type" IS '事件类型代码，tmpl_type为auto时，字典类型为auto_event_type(notice模块)，tmpl_type为manual时，字典类型为manual_event_type(notice模块)，';

COMMENT ON COLUMN "notice_tmpl"."publish_method" IS '发布方式代码，字典类型publish_method(notice模块)';

COMMENT ON COLUMN "notice_tmpl"."group_code" IS '模板分组代码,guid,用于区分同一事件下不同操作原因的多套模板';

COMMENT ON COLUMN "notice_tmpl"."active" IS '是否启用';

COMMENT ON COLUMN "notice_tmpl"."locale" IS '地区_语言';

COMMENT ON COLUMN "notice_tmpl"."title" IS '模板标题';

COMMENT ON COLUMN "notice_tmpl"."content" IS '模板内容';

COMMENT ON COLUMN "notice_tmpl"."default_active" IS '是否启用默认值';

COMMENT ON COLUMN "notice_tmpl"."default_title" IS '模板标题默认值';

COMMENT ON COLUMN "notice_tmpl"."default_content" IS '模板内容默认值';

COMMENT ON COLUMN "notice_tmpl"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_tmpl"."create_user" IS '创建用户id';

COMMENT ON COLUMN "notice_tmpl"."update_user" IS '更新用户id';

COMMENT ON COLUMN "notice_tmpl"."built_in" IS '是否系统内置';