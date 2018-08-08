-- auto gen by linsen 2018-07-09 10:28:02
-- 修复转账资金表 by linsen
CREATE TABLE IF NOT EXISTS "player_transfer_funds_repair" (
"id" serial4 NOT NULL,
"transaction_no" varchar(32) COLLATE "default" NOT NULL,
"api_transaction_id" varchar(64) COLLATE "default",
"api_id" int4 NOT NULL,
"transfer_type" varchar(32) COLLATE "default",
"user_id" int4 NOT NULL,
"user_name" varchar(32) COLLATE "default",
"transfer_amount" numeric(20,2),
"before_repair_status" varchar(32) COLLATE "default",
"after_repair_status" varchar(32) COLLATE "default",
"operate_id" int4 NOT NULL,
"operator" varchar(32) COLLATE "default" NOT NULL,
"operate_time" timestamp(6) DEFAULT now(),
CONSTRAINT "player_transfer_funds_repair_pkey" PRIMARY KEY ("id"),
CONSTRAINT "player_transfer_funds_repair_trans_no_ukey" UNIQUE ("transaction_no")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "player_transfer_funds_repair" IS '修复转账资金表';

COMMENT ON COLUMN "player_transfer_funds_repair"."id" IS '主键';

COMMENT ON COLUMN "player_transfer_funds_repair"."transaction_no" IS '订单号';

COMMENT ON COLUMN "player_transfer_funds_repair"."api_transaction_id" IS 'API独立交易ID';

COMMENT ON COLUMN "player_transfer_funds_repair"."api_id" IS '原订单所属API';

COMMENT ON COLUMN "player_transfer_funds_repair"."transfer_type" IS '交易类型';

COMMENT ON COLUMN "player_transfer_funds_repair"."user_id" IS '玩家ID';

COMMENT ON COLUMN "player_transfer_funds_repair"."user_name" IS '玩家账号';

COMMENT ON COLUMN "player_transfer_funds_repair"."transfer_amount" IS '订单金额';

COMMENT ON COLUMN "player_transfer_funds_repair"."before_repair_status" IS '修复前订单状态';

COMMENT ON COLUMN "player_transfer_funds_repair"."after_repair_status" IS '修复后订单状态';

COMMENT ON COLUMN "player_transfer_funds_repair"."operate_id" IS '操作者id';

COMMENT ON COLUMN "player_transfer_funds_repair"."operator" IS '操作者账号';

COMMENT ON COLUMN "player_transfer_funds_repair"."operate_time" IS '操作时间';
