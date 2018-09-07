-- auto gen by linsen 2018-08-20 14:13:38
--出款账户表 by linsen
CREATE TABLE IF NOT EXISTS "withdraw_account" (
"id" SERIAL4 NOT NULL,
"withdraw_name" varchar(100) COLLATE "default" NOT NULL,
"account" varchar(200) COLLATE "default" NOT NULL,
"status" varchar COLLATE "default" DEFAULT 1,
"create_time" timestamp(6),
"create_user" int4,
"update_time" timestamp(6),
"update_user" int4,
"bank_code" varchar(50) COLLATE "default",
"code" varchar(10) COLLATE "default",
"withdraw_count" int4 DEFAULT 0,
"withdraw_total" numeric(20,2) DEFAULT 0,
"channel_json" text COLLATE "default",
"remark" varchar(512) COLLATE "default",

CONSTRAINT "withdraw_account_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "withdraw_account" IS '出款(代付)账户表--linsen';

COMMENT ON COLUMN "withdraw_account"."withdraw_name" IS '账户名称';

COMMENT ON COLUMN "withdraw_account"."account" IS '账号';

COMMENT ON COLUMN "withdraw_account"."status" IS '状态(1使用中；2已停用；3被冻结；4已删除)(字典表pay_account_status)';

COMMENT ON COLUMN "withdraw_account"."create_time" IS '创建时间';

COMMENT ON COLUMN "withdraw_account"."create_user" IS '创建人';

COMMENT ON COLUMN "withdraw_account"."update_time" IS '最后更新时间';

COMMENT ON COLUMN "withdraw_account"."update_user" IS '最后更新人';

COMMENT ON COLUMN "withdraw_account"."bank_code" IS '渠道(bank表的bank_name）';

COMMENT ON COLUMN "withdraw_account"."code" IS '代号';

COMMENT ON COLUMN "withdraw_account"."withdraw_count" IS '累计出款次数';

COMMENT ON COLUMN "withdraw_account"."withdraw_total" IS '累计出款金额';

COMMENT ON COLUMN "withdraw_account"."channel_json" IS '第三方接口的参数json[{column:"字段",value:"值"}]';

COMMENT ON COLUMN "withdraw_account"."remark" IS '备注内容';

