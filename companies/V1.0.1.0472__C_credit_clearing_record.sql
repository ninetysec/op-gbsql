-- auto gen by george 2017-11-15 19:04:11

CREATE TABLE IF NOT EXISTS "credit_clearing_record" (
"id" serial4 NOT NULL PRIMARY KEY,
"site_id" int4,
"period" varchar(32),
"center_id" int4,
"master_id" int4,
"master_name" varchar(32),
"total_deposit_amount" numeric(20,2),
"clearing_amount" numeric(20,2),
"clearing_time" timestamp(6),
"clearing_user_id" int4,
"clearing_username" varchar(32),
"remark" text
);

COMMENT ON TABLE credit_clearing_record IS '清算记录表-younger';
COMMENT ON COLUMN "credit_clearing_record"."id" IS '主键';
COMMENT ON COLUMN "credit_clearing_record"."site_id" IS '站点ID';
COMMENT ON COLUMN "credit_clearing_record"."period" IS '期数';
COMMENT ON COLUMN "credit_clearing_record"."center_id" IS '运营商ID';
COMMENT ON COLUMN "credit_clearing_record"."master_id" IS '站长ID';
COMMENT ON COLUMN "credit_clearing_record"."master_name" IS '站长账号';
COMMENT ON COLUMN "credit_clearing_record"."total_deposit_amount" IS '本月充值总额';
COMMENT ON COLUMN "credit_clearing_record"."clearing_amount" IS '清算额度';
COMMENT ON COLUMN "credit_clearing_record"."clearing_time" IS '清算时间';
COMMENT ON COLUMN "credit_clearing_record"."clearing_user_id" IS '清算人ID';
COMMENT ON COLUMN "credit_clearing_record"."clearing_username" IS '清算人';
COMMENT ON COLUMN "credit_clearing_record"."remark" IS '备注';