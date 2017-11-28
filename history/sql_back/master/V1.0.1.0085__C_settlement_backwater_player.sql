-- auto gen by cheery 2015-09-21 05:50:43
--创建玩家返水表
CREATE TABLE IF NOT EXISTS "settlement_backwater_player" (
"id" SERIAL4 NOT NULL,
"settlement_backwater_id" int4,
"player_id" int4,
"username" varchar(100) ,
"rank_id" int4,
"rank_name" varchar(50) ,
"risk_marker" bool,
"backwater_total" numeric(20,2),
"backwater_actual" numeric(20,2),
"settlement_state" varchar(32) ,
"remark" varchar(1000) ,
"reason_title" varchar(128),
"reason_content" varchar(1000) ,
CONSTRAINT "settlement_backwater_player_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "settlement_backwater_player" OWNER TO "postgres";

COMMENT ON TABLE "settlement_backwater_player" IS '玩家返水表--suyj';
COMMENT ON COLUMN "settlement_backwater_player"."id" IS '主键';
COMMENT ON COLUMN "settlement_backwater_player"."settlement_backwater_id" IS 'settlement_backwater表id';
COMMENT ON COLUMN "settlement_backwater_player"."player_id" IS '玩家id';
COMMENT ON COLUMN "settlement_backwater_player"."username" IS '玩家账户名';
COMMENT ON COLUMN "settlement_backwater_player"."rank_id" IS '层级id';
COMMENT ON COLUMN "settlement_backwater_player"."rank_name" IS '层级名称';
COMMENT ON COLUMN "settlement_backwater_player"."risk_marker" IS '层级危险标识';
COMMENT ON COLUMN "settlement_backwater_player"."backwater_total" IS '应付返水';
COMMENT ON COLUMN "settlement_backwater_player"."backwater_actual" IS '实际返水';
COMMENT ON COLUMN "settlement_backwater_player"."settlement_state" IS '结算状态: operation.settlement_state';
COMMENT ON COLUMN "settlement_backwater_player"."remark" IS '备注';
COMMENT ON COLUMN "settlement_backwater_player"."reason_title" IS '原因标题';
COMMENT ON COLUMN "settlement_backwater_player"."reason_content" IS '原因内容';
