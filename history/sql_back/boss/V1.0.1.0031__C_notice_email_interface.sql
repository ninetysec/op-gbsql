-- auto gen by cheery 2015-12-17 14:30:24
--创建邮件通知接口接口表
CREATE TABLE if NOT EXISTS notice_email_interface(
 id  SERIAL4 NOT NULL PRIMARY KEY,
 user_group_type varchar(16),
 user_group_id int4,
 server_address varchar(128) NOT NULL,
 server_port varchar(5),
 email_account varchar(64) NOT NULL ,
 account_password VARCHAR(64) NOT NULL ,
 built_in bool NOT NULL DEFAULT FALSE ,
 name varchar(32) NOT NULL ,
 create_time timestamp(6) NOT NULL ,
 update_time timestamp(6),
 send_count int4 NOT NULL DEFAULT 0 ,
 status VARCHAR(1),
 reply_email_account varchar(64),
 test_email_account varchar(64)
);

comment ON TABLE notice_email_interface IS '邮件通知接口 -- Kevice';
comment ON  COLUMN notice_email_interface.id IS '主键';
comment ON  COLUMN notice_email_interface.user_group_type IS '用户群组类型';
comment ON  COLUMN notice_email_interface.user_group_id IS '用户群组id';
comment ON  COLUMN notice_email_interface.server_address IS '邮件服务器地址';
comment ON  COLUMN notice_email_interface.server_port IS '邮件服务器端口号';
comment ON  COLUMN notice_email_interface.email_account IS '邮件发送账号';
comment ON  COLUMN notice_email_interface.account_password IS '邮件发送账号密码';
comment ON  COLUMN notice_email_interface.built_in IS '系统内置';
comment ON  COLUMN notice_email_interface.name IS '接口名称';
comment ON  COLUMN notice_email_interface.create_time IS '创建时间';
comment ON  COLUMN notice_email_interface.update_time IS '更新时间';
comment ON  COLUMN notice_email_interface.send_count IS '发送次数';
comment ON  COLUMN notice_email_interface.status IS '状态，字典类型email_interface_status(notice模块)';
comment ON  COLUMN notice_email_interface.reply_email_account IS '邮件回复账号';
comment ON  COLUMN notice_email_interface.test_email_account IS '邮件测试账号';

CREATE OR replace  VIEW v_notice_email_interface AS
SELECT a.id,
    a.user_group_type,
    a.user_group_id,
    a.server_address,
    a.server_port,
    a.email_account,
    a.account_password,
    a.built_in,
    a.name,
    a.create_time,
    a.update_time,
    a.send_count,
    a.status,
    '' as remarks,
    '' as define_table,
    '' AS user_group_name,
    a.reply_email_account,
    a.test_email_account
   FROM notice_email_interface a;


   CREATE TABLE if NOT EXISTS "notice_tmpl" (
"id" serial4 NOT NULL,
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
