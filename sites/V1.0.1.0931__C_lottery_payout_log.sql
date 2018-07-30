-- auto gen by marz 2018-07-30 11:06:43
DROP TABLE IF EXISTS "lottery_payout_log";

DROP SEQUENCE IF EXISTS "lottery_payout_log_id_seq";
CREATE SEQUENCE "lottery_payout_log_id_seq" INCREMENT BY 1 MINVALUE 10000 START WITH 10000;

CREATE TABLE "lottery_payout_log" (
"id" int4 DEFAULT nextval('lottery_payout_log_id_seq'::regclass) NOT NULL,
"expect" varchar(32) COLLATE "default",
"code" varchar(32) COLLATE "default",
"type" varchar(32) COLLATE "default",
"open_code" varchar(128) COLLATE "default",
"create_time" timestamp(6),
"status" varchar(2) COLLATE "default",
"remark" text COLLATE "default",
"payout_hash" varchar(50) COLLATE "default",
CONSTRAINT "lottery_payout_log_pkey" PRIMARY KEY ("id"),
CONSTRAINT "unique_payout_hash" UNIQUE ("payout_hash")
)
WITH (OIDS=FALSE)
;
COMMENT ON TABLE "lottery_payout_log" IS '站点派彩记录表';
COMMENT ON COLUMN "lottery_payout_log"."id" IS '主键';
COMMENT ON COLUMN "lottery_payout_log"."expect" IS '开奖期数';
COMMENT ON COLUMN "lottery_payout_log"."code" IS '彩种代号';
COMMENT ON COLUMN "lottery_payout_log"."type" IS '彩种类型';
COMMENT ON COLUMN "lottery_payout_log"."open_code" IS '开奖号码';
COMMENT ON COLUMN "lottery_payout_log"."create_time" IS '入库时间';
COMMENT ON COLUMN "lottery_payout_log"."status" IS '状态';
COMMENT ON COLUMN "lottery_payout_log"."remark" IS '备注';
COMMENT ON COLUMN "lottery_payout_log"."payout_hash" IS '开奖hash，避免同时开奖';