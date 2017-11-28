-- auto gen by cheery
--创建站务其他账单表
CREATE TABLE IF NOT EXISTS "station_bill_other" (
"id" SERIAL4 NOT NULL,
"station_bill_id" int4,
"project_name" varchar(100) COLLATE "default",
"amount_payable" numeric(20,2),
"remark" varchar(1000) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "station_bill_other" IS '站务其他账单--suyj';
COMMENT ON COLUMN "station_bill_other"."id" IS '主键';
COMMENT ON COLUMN "station_bill_other"."station_bill_id" IS '站务账单ID';
COMMENT ON COLUMN "station_bill_other"."project_name" IS '项目名称';
COMMENT ON COLUMN "station_bill_other"."amount_payable" IS '应付金额';
COMMENT ON COLUMN "station_bill_other"."remark" IS '备注';