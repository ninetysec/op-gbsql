-- auto gen by cherry 2017-07-04 10:29:14
CREATE TABLE IF not EXISTS "lottery_payout_record" (
"id" serial4 NOT NULL PRIMARY KEY,
"site_id" int4,
"expect" varchar(32) ,
"code" varchar(32) ,
"type" varchar(32) ,
"open_code" varchar(128) ,
"create_time" timestamp(6),
"status" varchar(2) ,
"remark" text
);

ALTER TABLE "lottery_payout_record" OWNER TO "postgres";

COMMENT ON TABLE "lottery_payout_record" IS '派彩记录表';

COMMENT ON COLUMN "lottery_payout_record"."id" IS '主键';

COMMENT ON COLUMN "lottery_payout_record"."site_id" IS '站点ID';

COMMENT ON COLUMN "lottery_payout_record"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_payout_record"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_payout_record"."type" IS '彩种类型';

COMMENT ON COLUMN "lottery_payout_record"."open_code" IS '开奖号码';

COMMENT ON COLUMN "lottery_payout_record"."create_time" IS '入库时间';

COMMENT ON COLUMN "lottery_payout_record"."status" IS '状态';

COMMENT ON COLUMN "lottery_payout_record"."remark" IS '备注';