-- auto gen by steffan 2018-09-13 11:21:07

CREATE TABLE if not exists "recharge_fee_schema" (
"id" serial NOT NULL,
"schema_name" varchar(150) COLLATE "default" NOT NULL,
"is_fee" bool DEFAULT false NOT NULL,
"fee_time" int4,
"free_count" int4,
"max_fee" numeric(20,2),
"fee_type" varchar(10) COLLATE "default",
"fee_money" numeric(20,2),
"is_return_fee" bool DEFAULT false NOT NULL,
"reach_money" numeric(20,2),
"max_return_fee" numeric(20,2),
"return_time" int4,
"return_fee_count" int4,
"return_type" varchar(10) COLLATE "default",
"return_money" numeric(20,2),
"favorable_audit" int4,
"create_user" varchar(32) COLLATE "default",
"create_time" timestamp(6),
"update_user" varchar(32) COLLATE "default",
"update_time" timestamp(6),
"is_delete" bool DEFAULT false NOT NULL,
CONSTRAINT "recharge_fee_schema_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;



COMMENT ON TABLE "recharge_fee_schema" IS '存款手续费方案表 - martin';

COMMENT ON COLUMN "recharge_fee_schema"."id" IS '主键';

COMMENT ON COLUMN "recharge_fee_schema"."schema_name" IS '手续费方案名称';

COMMENT ON COLUMN "recharge_fee_schema"."is_fee" IS '是否收取手续费(true:是/false:否)';

COMMENT ON COLUMN "recharge_fee_schema"."fee_time" IS '手续费时限(小时)';

COMMENT ON COLUMN "recharge_fee_schema"."free_count" IS '免手续费次数';

COMMENT ON COLUMN "recharge_fee_schema"."max_fee" IS '手续费上限金额(CNY)';

COMMENT ON COLUMN "recharge_fee_schema"."fee_type" IS '手续费收取方式(1按比例；2固定)';

COMMENT ON COLUMN "recharge_fee_schema"."fee_money" IS '存款手续费金额(当fee_type=1的时候fee_money代表比例，当fee_type=2的时候fee_money代表金额)';

COMMENT ON COLUMN "recharge_fee_schema"."is_return_fee" IS '是否返还手续费(true:是/false:否)';

COMMENT ON COLUMN "recharge_fee_schema"."reach_money" IS '满存金额';

COMMENT ON COLUMN "recharge_fee_schema"."max_return_fee" IS '存款返手续费上限金额';

COMMENT ON COLUMN "recharge_fee_schema"."return_time" IS '存款返手续费时限/小时';

COMMENT ON COLUMN "recharge_fee_schema"."return_fee_count" IS '存款返手续费次数';

COMMENT ON COLUMN "recharge_fee_schema"."return_type" IS '存款返手续费方式（1按比例；2固定）';

COMMENT ON COLUMN "recharge_fee_schema"."return_money" IS '存款返手续费金额（当return_type=1的时候return_money代表比例，当return_type=2的时候return_money代表金额）';

COMMENT ON COLUMN "recharge_fee_schema"."favorable_audit" IS '优惠稽核';

COMMENT ON COLUMN "recharge_fee_schema"."create_user" IS '创建人';

COMMENT ON COLUMN "recharge_fee_schema"."create_time" IS '创建时间';

COMMENT ON COLUMN "recharge_fee_schema"."update_user" IS '修改人';

COMMENT ON COLUMN "recharge_fee_schema"."update_time" IS '修改时间';

COMMENT ON COLUMN "recharge_fee_schema"."is_delete" IS '是否删除(true/false)';