-- auto gen by longer 2015-12-03 14:48:34
-- from orange

CREATE TABLE IF NOT EXISTS "notice_email_interface" (
  "id" SERIAL4 NOT NULL,
  "user_group_type" varchar(16) COLLATE "default",
  "user_group_id" int4,
  "server_address" varchar(128) COLLATE "default" NOT NULL,
  "server_port" varchar(5) COLLATE "default",
  "email_account" varchar(64) COLLATE "default" NOT NULL,
  "account_password" varchar(64) COLLATE "default" NOT NULL,
  "built_in" bool DEFAULT false NOT NULL,
  "name" varchar(32) COLLATE "default" NOT NULL,
  "create_time" timestamp(6) NOT NULL,
  "update_time" timestamp(6),
  "send_count" int4 DEFAULT 0 NOT NULL,
  "status" varchar(1) COLLATE "default" DEFAULT 1 NOT NULL,
  "reply_email_account" varchar(64) COLLATE "default",
  "test_email_account" varchar(64) COLLATE "default",
  CONSTRAINT "notice_email_interface_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_email_interface" OWNER TO "postgres";

COMMENT ON TABLE "notice_email_interface" IS '邮件通知接口 -- Kevice';

COMMENT ON COLUMN "notice_email_interface"."id" IS '主键';

COMMENT ON COLUMN "notice_email_interface"."user_group_type" IS '用户群组类型';

COMMENT ON COLUMN "notice_email_interface"."user_group_id" IS '用户群组id';

COMMENT ON COLUMN "notice_email_interface"."server_address" IS '邮件服务器地址';

COMMENT ON COLUMN "notice_email_interface"."server_port" IS '邮件服务器端口号';

COMMENT ON COLUMN "notice_email_interface"."email_account" IS '邮件发送账号';

COMMENT ON COLUMN "notice_email_interface"."account_password" IS '邮件发送账号密码';

COMMENT ON COLUMN "notice_email_interface"."built_in" IS '系统内置';

COMMENT ON COLUMN "notice_email_interface"."name" IS '接口名称';

COMMENT ON COLUMN "notice_email_interface"."create_time" IS '创建时间';

COMMENT ON COLUMN "notice_email_interface"."update_time" IS '更新时间';

COMMENT ON COLUMN "notice_email_interface"."send_count" IS '发送次数';

COMMENT ON COLUMN "notice_email_interface"."status" IS '状态，字典类型email_interface_status(notice模块)';

COMMENT ON COLUMN "notice_email_interface"."reply_email_account" IS '邮件回复账号';

COMMENT ON COLUMN "notice_email_interface"."test_email_account" IS '邮件测试账号';


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
  CONSTRAINT "notice_tmpl_pkey" PRIMARY KEY ("id")
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


select redo_sqls($$
    ALTER TABLE "system_announcement" ADD COLUMN "publish_user_name" varchar(32);
    ALTER TABLE "system_announcement" ADD COLUMN "operate_time" timestamp(6);
    ALTER TABLE "system_announcement" ADD COLUMN "api_id" int4;
$$);

COMMENT ON COLUMN "system_announcement"."publish_user_name" IS '发布人账号';
COMMENT ON COLUMN "system_announcement"."operate_time" IS '操作时间';
COMMENT ON COLUMN "system_announcement"."announcement_type" IS '公告类型operation.announcement_type(系统公告gg,运营公告,平台公告,游戏公告)';
COMMENT ON COLUMN "system_announcement"."api_id" IS 'api主键，仅游戏公告该字段有值';


DROP VIEW IF EXISTS v_system_announcement;
CREATE OR REPLACE VIEW "v_system_announcement" AS
  SELECT s.id,
    s.release_mode,
    s.publish_time,
    s.publish_user_id,
    a.local,
    a.title,
    a.content,
    u.username,
    s.announcement_type,
    s.publish_platform,
    s.publish_user_name,
    s.operate_time,
    s.api_id
  FROM ((system_announcement s
  LEFT JOIN system_announcement_i18n a ON ((a.system_announcement_id = s.id)))
         LEFT JOIN sys_user u ON ((u.id = s.publish_user_id)));

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_system_announcement" IS '系统公告视图 --orange';

CREATE TABLE IF NOT EXISTS "station_letter_sign" (
  "id" SERIAL4 NOT NULL,
  "sign_id" int4,
  "is_sign" bool,
  CONSTRAINT "notice_sign_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "station_letter_sign" OWNER TO "postgres";

COMMENT ON TABLE "station_letter_sign" IS '系统消息标记表-orange';

COMMENT ON COLUMN "station_letter_sign"."id" IS '主键id';

COMMENT ON COLUMN "station_letter_sign"."sign_id" IS '标记系统消息id';

COMMENT ON COLUMN "station_letter_sign"."is_sign" IS '是否标记';

CREATE OR REPLACE VIEW "v_notice_received_text" AS
  SELECT r.id,
    r.receiver_id,
    r.status AS receive_status,
    r.create_time AS receive_time,
    s.publish_method,
    s.comet_subscribe_type,
    s.remind_method,
    s.locale,
    s.orig_send_id,
    t.title,
    t.content,
    COALESCE(( SELECT station_letter_sign.is_sign
               FROM station_letter_sign
               WHERE (station_letter_sign.sign_id = r.id)), false) AS is_sign
  FROM ((notice_receive r
  LEFT JOIN notice_send s ON ((r.send_id = s.id)))
         LEFT JOIN notice_text t ON ((s.text_id = t.id)));

ALTER TABLE "v_notice_received_text" OWNER TO "postgres";
COMMENT ON VIEW "v_notice_received_text" IS '站内信视图--orange';

