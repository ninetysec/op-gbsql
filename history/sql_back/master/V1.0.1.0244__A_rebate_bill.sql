select redo_sqls($$
    ALTER TABLE "rebate_api" ADD COLUMN "effective_transaction" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_api" ADD COLUMN "profit_loss" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_player" ADD COLUMN "refund_fee" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_player" ADD COLUMN "recommend" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_player" ADD COLUMN "apportion" numeric(20,2) DEFAULT 0;

    ALTER TABLE "rebate_agent" ADD COLUMN "recommend" numeric(20,2) DEFAULT 0;

    ALTER TABLE "rebate_bill" ADD COLUMN "effective_transaction" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "profit_loss" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "refund_fee" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "recommend" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "backwater" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "preferential_value" numeric(20,2) DEFAULT 0;
    ALTER TABLE "rebate_bill" ADD COLUMN "apportion" numeric(20,2) DEFAULT 0;
$$);
COMMENT ON COLUMN "rebate_api"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "rebate_api"."profit_loss" IS '总交易盈亏';
COMMENT ON COLUMN "rebate_player"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "rebate_player"."recommend" IS '推荐优惠';
COMMENT ON COLUMN "rebate_player"."apportion" IS '分摊费用';
COMMENT ON COLUMN "rebate_agent"."recommend" IS '推荐优惠';

COMMENT ON COLUMN "rebate_bill"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "rebate_bill"."profit_loss" IS '总交易盈亏';
COMMENT ON COLUMN "rebate_bill"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "rebate_bill"."recommend" IS '推荐优惠';
COMMENT ON COLUMN "rebate_bill"."backwater" IS '返水';
COMMENT ON COLUMN "rebate_bill"."preferential_value" IS '优惠';
COMMENT ON COLUMN "rebate_bill"."apportion" IS '分摊费用';
