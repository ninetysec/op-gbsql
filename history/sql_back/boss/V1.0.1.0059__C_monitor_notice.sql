-- auto gen by Jason 2016-01-18 03:54:51

CREATE TABLE IF NOT EXISTS "notice_send" (
  "id" SERIAL4 NOT NULL,
  "receiver_group_type" varchar(16) COLLATE "default" NOT NULL,
  "receiver_group_id" int4,
  "text_id" int4 NOT NULL,
  "publish_method" varchar(16) COLLATE "default" NOT NULL,
  "comet_subscribe_type" varchar(32) COLLATE "default",
  "remind_method" varchar(16) COLLATE "default",
  "locale" varchar(5) COLLATE "default" NOT NULL,
  "status" varchar(2) COLLATE "default" NOT NULL,
  "orig_send_id" int4,
  "create_time" timestamp(6) NOT NULL,
  "update_time" timestamp(6),
  "cron_exp" varchar(64) COLLATE "default",
  "success_count" int4 DEFAULT 0,
  "fail_count" int4 DEFAULT 0,
  "job_code" varchar(32) COLLATE "default",
  CONSTRAINT "notice_send_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_send" OWNER TO "postgres";

COMMENT ON TABLE "notice_send" IS '通知发送 -- Kevice';

COMMENT ON COLUMN "notice_send"."id" IS '主键';

COMMENT ON COLUMN "notice_send"."receiver_group_type" IS '接收者群组类型代码，字典为receiver_group_type(notice模块)';

COMMENT ON COLUMN "notice_send"."receiver_group_id" IS '接收者群组id';

COMMENT ON COLUMN "notice_send"."text_id" IS '通知id';

COMMENT ON COLUMN "notice_send"."publish_method" IS '发布方式代码，字典类型publish_method(notice模块)';

COMMENT ON COLUMN "notice_send"."comet_subscribe_type" IS 'comet订阅类型代码，字典类型为comet_subscribe_type(notice模块)';

COMMENT ON COLUMN "notice_send"."remind_method" IS '提醒方式代码，字典类型remind_method(notice模块)';

COMMENT ON COLUMN "notice_send"."locale" IS '地区_语言';

COMMENT ON COLUMN "notice_send"."status" IS '发送状态代码，字典类型为send_status(notice模块)';

COMMENT ON COLUMN "notice_send"."orig_send_id" IS '源发送id, 当将comet作为一种提醒方式时有值';

COMMENT ON COLUMN "notice_send"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_send"."update_time" IS '更新时间';

COMMENT ON COLUMN "notice_send"."cron_exp" IS '定时发布的cron表达式，为空表示立即发布';

COMMENT ON COLUMN "notice_send"."success_count" IS '发送成功数量';

COMMENT ON COLUMN "notice_send"."fail_count" IS '发送失败数量';

COMMENT ON COLUMN "notice_send"."job_code" IS '定时任务的编码';




CREATE TABLE IF NOT EXISTS "notice_text" (
  "id" SERIAL4 NOT NULL,
  "locale" varchar(5) COLLATE "default" NOT NULL,
  "title" varchar(128) COLLATE "default" NOT NULL,
  "content" text COLLATE "default" NOT NULL,
  "tmpl_id" int4,
  "create_time" timestamp(6) NOT NULL,
  "create_user" int4,
  "tmpl_title" varchar(128) COLLATE "default",
  "tmpl_content" text COLLATE "default",
  "create_username" varchar(32) COLLATE "default" NOT NULL,
  "tmpl_params" varchar(255) COLLATE "default",
  "remarks" varchar(255) COLLATE "default",
  "event_type" varchar(32) COLLATE "default",
  "publish_method" varchar(16) COLLATE "default",
  CONSTRAINT "notice_text_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_text" OWNER TO "postgres";

COMMENT ON TABLE "notice_text" IS '通知文本 -- Kevice';

COMMENT ON COLUMN "notice_text"."id" IS '主键';

COMMENT ON COLUMN "notice_text"."locale" IS '地区_语言';

COMMENT ON COLUMN "notice_text"."title" IS '标题';

COMMENT ON COLUMN "notice_text"."content" IS '通知内容';

COMMENT ON COLUMN "notice_text"."tmpl_id" IS '通知模板id';

COMMENT ON COLUMN "notice_text"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_text"."create_user" IS '创建用户id';

COMMENT ON COLUMN "notice_text"."tmpl_title" IS '模板标题';

COMMENT ON COLUMN "notice_text"."tmpl_content" IS '模板内容';

COMMENT ON COLUMN "notice_text"."create_username" IS '创建用户账号';

COMMENT ON COLUMN "notice_text"."tmpl_params" IS '模板参数json串';

COMMENT ON COLUMN "notice_text"."remarks" IS '备注';

COMMENT ON COLUMN "notice_text"."event_type" IS '事件类型代码';

COMMENT ON COLUMN "notice_text"."publish_method" IS '发布方式代码，字典类型publish_method(notice模块)';


CREATE TABLE IF NOT EXISTS "notice_unreceived" (
  "id" SERIAL4 NOT NULL,
  "user_id" int4 NOT NULL,
  "send_ids" text COLLATE "default" NOT NULL,
  "publish_method" varchar(16) COLLATE "default" NOT NULL,
  "create_time" timestamp(6) NOT NULL,
  "update_time" timestamp(6),
  CONSTRAINT "notice_unreceived_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "notice_unreceived_user_id_publish_method_key" UNIQUE ("user_id", "publish_method")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_unreceived" OWNER TO "postgres";

COMMENT ON TABLE "notice_unreceived" IS '还未收到的消息 -- Kevice';

COMMENT ON COLUMN "notice_unreceived"."id" IS '主键';

COMMENT ON COLUMN "notice_unreceived"."user_id" IS '用户id';

COMMENT ON COLUMN "notice_unreceived"."send_ids" IS '发送的消息id(以半角逗号分隔)';

COMMENT ON COLUMN "notice_unreceived"."publish_method" IS '发布方式代码，字典类型publish_method(notice模块)';

COMMENT ON COLUMN "notice_unreceived"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_unreceived"."update_time" IS '更新时间';



CREATE TABLE IF NOT EXISTS "notice_receive" (
  "id" SERIAL4 NOT NULL,
  "receiver_id" int4 NOT NULL,
  "send_id" int4 NOT NULL,
  "status" varchar(2) COLLATE "default" NOT NULL,
  "create_time" timestamp(6) NOT NULL,
  "update_time" timestamp(6),
  "tmpl_params" varchar(128) COLLATE "default",
  "receiver_username" varchar(32) COLLATE "default" NOT NULL,
  CONSTRAINT "notice_receive_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_receive" OWNER TO "postgres";

COMMENT ON TABLE "notice_receive" IS '通知接收 -- Kevice';

COMMENT ON COLUMN "notice_receive"."id" IS '主键';

COMMENT ON COLUMN "notice_receive"."receiver_id" IS '接收者id';

COMMENT ON COLUMN "notice_receive"."send_id" IS '通知发送id';

COMMENT ON COLUMN "notice_receive"."status" IS '接收状态代码，字典类型为receive_status(notice模块)';

COMMENT ON COLUMN "notice_receive"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_receive"."update_time" IS '更新时间';

COMMENT ON COLUMN "notice_receive"."tmpl_params" IS '模板参数(与具体用户相关的)json串';

COMMENT ON COLUMN "notice_receive"."receiver_username" IS '接收者账号';


CREATE TABLE IF NOT EXISTS "notice_receiver_group" (
  "id" SERIAL4 NOT NULL,
  "type" varchar(16) COLLATE "default" NOT NULL,
  "remarks" varchar(32) COLLATE "default",
  "define_table" varchar(64) COLLATE "default" NOT NULL,
  "name_column" varchar(64) COLLATE "default" NOT NULL,
  CONSTRAINT "notice_receiver_group_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_receiver_group" OWNER TO "postgres";

COMMENT ON TABLE "notice_receiver_group" IS '通知接收者群组 -- Kevice';

COMMENT ON COLUMN "notice_receiver_group"."id" IS '主键';

COMMENT ON COLUMN "notice_receiver_group"."type" IS '接收者群组类型代码，字典为receiver_group_type(notice模块)';

COMMENT ON COLUMN "notice_receiver_group"."remarks" IS '群组描述';

COMMENT ON COLUMN "notice_receiver_group"."define_table" IS '群组定义的表';

COMMENT ON COLUMN "notice_receiver_group"."name_column" IS '群组名称在具体群组表中的字段名';


select redo_sqls($$
ALTER TABLE "notice_send"
ADD COLUMN "actual_receiver" varchar(64);

COMMENT ON COLUMN "notice_send"."actual_receiver" IS '实际接收者：目前仅支持邮件发送方式，存储的是实际邮箱地址。';
$$);
