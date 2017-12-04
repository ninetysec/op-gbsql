-- auto gen by cherry 2017-07-29 16:37:39
CREATE TABLE if NOT EXISTS "credit_account" (
"id" serial4 NOT NULL PRIMARY key,
"pay_name" varchar(100) NOT NULL,
"account" varchar(200) NOT NULL,
"full_name" varchar(200) ,
"pay_key" varchar(200) ,
"status" varchar DEFAULT 1,
"create_time" timestamp(6),
"create_user" int4,
"type" varchar(50) DEFAULT 1,
"account_type" varchar(50) DEFAULT 1 NOT NULL,
"bank_code" varchar(50) ,
"pay_url" varchar(200) ,
"deposit_count" int4 DEFAULT 0,
"deposit_total" numeric(20,2) DEFAULT 0,
"deposit_default_count" int4 DEFAULT 0,
"deposit_default_total" numeric(20,2) DEFAULT 0,
"single_deposit_min" int4,
"single_deposit_max" int4,
"frozen_time" timestamp(6),
"channel_json" text ,
"custom_bank_name" varchar(32) ,
"open_acount_name" varchar(100) ,
"qr_code_url" varchar(200) ,
"remark" varchar(512) ,
"terminal" varchar(2) ,
"disable_amount" int4,
sort int2
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "credit_account" IS '买分收款账户表--cherry';

COMMENT ON COLUMN "credit_account"."pay_name" IS '账户名称';

COMMENT ON COLUMN "credit_account"."account" IS '账号';

COMMENT ON COLUMN "credit_account"."full_name" IS '姓名';

COMMENT ON COLUMN "credit_account"."pay_key" IS 'Key';

COMMENT ON COLUMN "credit_account"."status" IS '状态(1使用中；2已停用；3被冻结；4已删除)';

COMMENT ON COLUMN "credit_account"."create_time" IS '创建时间';

COMMENT ON COLUMN "credit_account"."create_user" IS '创建人';

COMMENT ON COLUMN "credit_account"."type" IS '类型（1公司入款；2线上支付）';

COMMENT ON COLUMN "credit_account"."account_type" IS '账户类型（1银行账户；2第三方账户）';

COMMENT ON COLUMN "credit_account"."bank_code" IS '渠道(bank表的bank_name）';

COMMENT ON COLUMN "credit_account"."pay_url" IS '支付URL地址';

COMMENT ON COLUMN "credit_account"."deposit_count" IS '累计入款次数';

COMMENT ON COLUMN "credit_account"."deposit_total" IS '累计入款金额';

COMMENT ON COLUMN "credit_account"."deposit_default_count" IS '一个周期内累计入款次数';

COMMENT ON COLUMN "credit_account"."deposit_default_total" IS '一个周期内累计入款金额';

COMMENT ON COLUMN "credit_account"."single_deposit_min" IS '单笔存款最小值';

COMMENT ON COLUMN "credit_account"."single_deposit_max" IS '单笔存款最大值';

COMMENT ON COLUMN "credit_account"."frozen_time" IS '冻结时间';

COMMENT ON COLUMN "credit_account"."channel_json" IS '第三方接口的参数json[{column:"字段",value:"值"}]';

COMMENT ON COLUMN "credit_account"."custom_bank_name" IS '第三方自定义名称';

COMMENT ON COLUMN "credit_account"."open_acount_name" IS '开户行';

COMMENT ON COLUMN "credit_account"."qr_code_url" IS '第三方入款账户二维码图片路径';

COMMENT ON COLUMN "credit_account"."remark" IS '备注内容';

COMMENT ON COLUMN "credit_account"."terminal" IS '支持终端：0-全部 1-pc 2-终端';

COMMENT ON COLUMN "credit_account"."sort" IS '排序';

CREATE INDEX if not EXISTS "in_credit_account_account_type" ON "credit_account" USING btree (account_type);

CREATE INDEX if not EXISTS "in_credit_account_bank_code" ON "credit_account" USING btree (bank_code);

CREATE INDEX if not EXISTS "in_credit_account_create_time" ON "credit_account" USING btree (create_time);

CREATE INDEX if not EXISTS "in_credit_account_deposit_count" ON "credit_account" USING btree (deposit_count);

CREATE INDEX if not EXISTS "in_credit_account_deposit_total" ON "credit_account" USING btree (deposit_total);

CREATE INDEX if not EXISTS "in_credit_account_type" ON "credit_account" USING btree (type);

CREATE TABLE IF not EXISTS credit_record(
id serial4 not null PRIMARY key,
site_id int4,
transaction_no varchar(64),
pay_amount NUMERIC(20,2),
pay_scale NUMERIC(20,2),
credict_account_id int4,
pay_url varchar(64),
pay_user_name VARCHAR(32),
ip int8,
ip_dict_code varchar(100),
check_user int4,
check_name varchar(32),
create_time TIMESTAMP,
status varchar(2)
);

COMMENT ON TABLE credit_record is '买分记录';
COMMENT on COLUMN credit_record.site_id is '站点id';
COMMENT on COLUMN credit_record.transaction_no is '交易号';
COMMENT on COLUMN credit_record.pay_amount is '支付金额';
COMMENT on COLUMN credit_record.pay_scale is '买分比例';
COMMENT on COLUMN credit_record.credict_account_id is '买分充值账号';
COMMENT on COLUMN credit_record.pay_url is '支付域名';
COMMENT on COLUMN credit_record.pay_user_name is '支付账号';
COMMENT on COLUMN credit_record.ip is 'ip';
COMMENT on COLUMN credit_record.ip_dict_code is 'ip区域';
COMMENT on COLUMN credit_record.check_user is '审核人id';
COMMENT on COLUMN credit_record.check_name is '审核人';
COMMENT on COLUMN credit_record.create_time is '创建时间';
COMMENT on COLUMN credit_record.status is '状态';