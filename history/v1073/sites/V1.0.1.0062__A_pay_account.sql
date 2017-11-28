-- auto gen by cherry 2016-03-15 18:29:59
 select redo_sqls($$
       ALTER TABLE pay_account ADD COLUMN custom_bank_name varchar(32);
$$);

COMMENT ON COLUMN pay_account.custom_bank_name IS '第三方自定义名称';

COMMENT ON COLUMN pay_account."deposit_default_count" IS '一个周期内累计入款次数';

COMMENT ON COLUMN pay_account."deposit_default_total" IS '一个周期内累计入款金额';

create table IF NOT EXISTS pay_warning (
"id" SERIAL4 NOT NULL,

"account_type" varchar(32) COLLATE "default",

"warning_type" varchar(32) COLLATE "default",

"warning_level" varchar(32) COLLATE "default",

"warning_time" timestamp(6),

"warning_code" varchar(32) COLLATE "default",

"warning_content" varchar(2048) COLLATE "default",

CONSTRAINT "pay_warning_pkey" PRIMARY KEY ("id")
);

COMMENT ON COLUMN "pay_warning"."account_type" IS '收款账户类型RechargeTypeParentEnum（公司入款，在线支付）';

COMMENT ON COLUMN "pay_warning"."warning_type" IS '预警记录类型WarningTypeEnum（账户解冻，账户冻结，账户预警，层级账户不足）';

COMMENT ON COLUMN "pay_warning"."warning_level" IS '预警级别（红色，橙色，其他预警）';

COMMENT ON COLUMN "pay_warning"."warning_time" IS '预警时间';

COMMENT ON COLUMN  "pay_warning"."warning_code" IS '预警code(对应国际化的key)';

COMMENT ON COLUMN  "pay_warning"."warning_content" IS '预警内容（对应WarningContentVo）';

COMMENT ON TABLE "pay_warning" IS '账户预警表';