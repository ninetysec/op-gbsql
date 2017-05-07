-- ----------------------------
-- Table structure for favorable_scheme_detail
-- ----------------------------
DROP TABLE IF EXISTS "favorable_scheme_detail";
CREATE TABLE "favorable_scheme_detail" (
"id" serial4 NOT NULL,
"favorable_scheme_id" int4 NOT NULL,
"min_value" numeric(20,2) DEFAULT 0,
"max_value" numeric(20,2) DEFAULT 0,
"favorable_type" varchar(50),
"ratio" numeric(20,2) DEFAULT 0,
"amount" numeric(20,2) DEFAULT 0
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "favorable_scheme_detail" IS '包网优惠梯度API明细表--Lins';
COMMENT ON COLUMN "favorable_scheme_detail"."min_value" IS '盈利最小值(包含最小值)';
COMMENT ON COLUMN "favorable_scheme_detail"."max_value" IS '盈利最大值';
COMMENT ON COLUMN "favorable_scheme_detail"."favorable_type" IS '优惠方式.Dicts: Module:common  Dict_Type: favorable_type.0.默认值,以占成额来计算 1.以服务费来计算';
COMMENT ON COLUMN "favorable_scheme_detail"."favorable_scheme_id" IS '包网优惠表ID，favorable_scheme.id';
COMMENT ON COLUMN "favorable_scheme_detail"."ratio" IS '优惠比例,优惠金额取其一,默认:0';
COMMENT ON COLUMN "favorable_scheme_detail"."amount" IS '优惠金额,与优惠比例取其一,默认:0';

ALTER TABLE "favorable_scheme_detail" ADD PRIMARY KEY ("id");
