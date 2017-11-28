-- auto gen by bruce 2017-02-05 20:09:37
CREATE TABLE IF NOT EXISTS "activity_open_period" (
  "id" serial NOT NULL,
  "activity_message_id" INT4,
  "start_time" TIMESTAMP,
  "end_time" TIMESTAMP,
  CONSTRAINT "pk_open_period" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "activity_open_period" IS '优惠时间段 -- bruce';
COMMENT ON COLUMN "activity_open_period"."id" IS '主键';
COMMENT ON COLUMN "activity_open_period"."activity_message_id" IS '活动id';
COMMENT ON COLUMN "activity_open_period"."start_time" IS '开始时间';
COMMENT ON COLUMN "activity_open_period"."end_time" IS '结束时间';

CREATE TABLE IF NOT EXISTS "activity_awards_rules" (
  "id" serial NOT NULL,
  "activity_message_id" INT4,
  "amount" NUMERIC(20,2),
  "audit" NUMERIC(20,2),
  quantity INT4,
  probability NUMERIC(20,2),
  CONSTRAINT "pk_awards_rules" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "activity_awards_rules" IS '优惠活动奖项设置 -- bruce';
COMMENT ON COLUMN "activity_awards_rules"."id" IS '主键';
COMMENT ON COLUMN "activity_awards_rules"."activity_message_id" IS '活动id';
COMMENT ON COLUMN "activity_awards_rules"."amount" IS '奖项金额';
COMMENT ON COLUMN "activity_awards_rules"."audit" IS '稽核';
COMMENT ON COLUMN "activity_awards_rules"."quantity" IS '数量';
COMMENT ON COLUMN "activity_awards_rules"."probability" IS '中奖概率';