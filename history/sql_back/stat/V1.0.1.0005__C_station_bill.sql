-- auto gen by cheery
--创建站务账单表
CREATE TABLE IF NOT EXISTS "station_bill" (
"id" SERIAL4 NOT NULL,
"center_id" int4,
"master_id" int4,
"site_id" int4,
"bill_num" varchar(32) COLLATE "default",
"bill_name" varchar(100) COLLATE "default",
"start_time" timestamp(6),
"end_time" timestamp(6),
"amount_payable" numeric(20,2),
"last_operate_time" timestamp(6),
"user_id" int4,
"user_name" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "station_bill" IS '站务账单表--suyj';
COMMENT ON COLUMN "station_bill"."id" IS '主键';
COMMENT ON COLUMN "station_bill"."center_id" IS '运营商ID';
COMMENT ON COLUMN "station_bill"."master_id" IS '站长ID';
COMMENT ON COLUMN "station_bill"."site_id" IS '站点ID';
COMMENT ON COLUMN "station_bill"."bill_num" IS '账单流水号';
COMMENT ON COLUMN "station_bill"."bill_name" IS '账单名称';
COMMENT ON COLUMN "station_bill"."start_time" IS '账单起始时间';
COMMENT ON COLUMN "station_bill"."end_time" IS '账单结束时间';
COMMENT ON COLUMN "station_bill"."amount_payable" IS '应付金额';
COMMENT ON COLUMN "station_bill"."last_operate_time" IS '最后操作时间';
COMMENT ON COLUMN "station_bill"."user_id" IS '最后操作人ID';
COMMENT ON COLUMN "station_bill"."user_name" IS '最后操作人';