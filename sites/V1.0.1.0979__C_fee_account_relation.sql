-- auto gen by steffan 2018-09-13 11:21:20

CREATE TABLE  if not exists "fee_account_relation" (
"id" serial NOT NULL,
"fee_schema_id" int4,
"pay_account_id" int4,
CONSTRAINT "fee_account_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "fee_account_relation" IS '手续费方案与账户关系表 - martin';

COMMENT ON COLUMN "fee_account_relation"."id" IS '主键';

COMMENT ON COLUMN "fee_account_relation"."fee_schema_id" IS '手续费方案ID';

COMMENT ON COLUMN "fee_account_relation"."pay_account_id" IS '账户ID';