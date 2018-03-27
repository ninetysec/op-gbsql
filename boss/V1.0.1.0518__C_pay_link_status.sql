-- auto gen by linsen 2018-02-28 21:11:03
CREATE TABLE IF NOT EXISTS "pay_link_status"(
"id" SERIAL4 PRIMARY KEY,
"link_address" VARCHAR(1000) NOT NULL,
"channel_code" VARCHAR(32),
"last_test_time" TIMESTAMP(6),
"status" VARCHAR(32)
)
WITH (OIDS=FALSE);
COMMENT ON TABLE "pay_link_status" IS '支付请求状态表--Leo';
COMMENT ON COLUMN "pay_link_status"."id" IS '主键';
COMMENT ON COLUMN "pay_link_status"."link_address" IS '链接地址';
COMMENT ON COLUMN "pay_link_status"."channel_code" IS '渠道';
COMMENT ON COLUMN "pay_link_status"."last_test_time" IS '同步更新时间';
COMMENT ON COLUMN "pay_link_status"."status" IS '状态';