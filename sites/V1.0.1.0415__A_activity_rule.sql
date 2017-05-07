-- auto gen by cherry 2017-03-28 14:32:31
SELECT redo_sqls($$
  alter table activity_rule add column has_condition BOOLEAN;
  alter table activity_rule add column bet_count_max_limit INTEGER;
$$);

  COMMENT ON COLUMN activity_rule.has_condition IS '是否条件限制';
  COMMENT ON COLUMN activity_rule.bet_count_max_limit IS '单个玩家抽奖次数上限限制';

CREATE TABLE IF not EXISTS "activity_money_awards_rules" (

"id" SERIAL4 NOT NULL PRIMARY KEY,

"activity_message_id" int4,

"amount" numeric(20,2),

"audit" numeric(20,2),

"quantity" int4,

"probability" numeric(20,2)

);

COMMENT ON TABLE "activity_money_awards_rules" IS '优惠活动奖项设置 -- younger';

COMMENT ON COLUMN "activity_money_awards_rules"."id" IS '主键';

COMMENT ON COLUMN "activity_money_awards_rules"."activity_message_id" IS '活动id';

COMMENT ON COLUMN "activity_money_awards_rules"."amount" IS '奖项金额';

COMMENT ON COLUMN "activity_money_awards_rules"."audit" IS '稽核';

COMMENT ON COLUMN "activity_money_awards_rules"."quantity" IS '数量';

COMMENT ON COLUMN "activity_money_awards_rules"."probability" IS '中奖概率';

CREATE TABLE IF NOT EXISTS "activity_money_open_period" (

"id" SERIAL4 NOT NULL PRIMARY KEY,

"activity_message_id" int4,

start_time_hour int4,

start_time_minute int4,

end_time_hour int4,

end_time_minute int4

);

COMMENT ON TABLE "activity_money_open_period" IS '优惠时间段 -- younger';

COMMENT ON COLUMN "activity_money_open_period"."id" IS '主键';

COMMENT ON COLUMN "activity_money_open_period"."activity_message_id" IS '活动id';

COMMENT ON COLUMN "activity_money_open_period"."start_time_hour" IS '开始时段小时';

COMMENT ON COLUMN "activity_money_open_period"."start_time_minute" IS '开始时段分钟';

COMMENT ON COLUMN "activity_money_open_period"."end_time_hour" IS '结束时段小时';

COMMENT ON COLUMN "activity_money_open_period"."end_time_minute" IS '结束时段分钟';

CREATE TABLE IF NOT EXISTS "activity_money_condition" (

"id" SERIAL4 NOT NULL PRIMARY KEY,

"activity_message_id" int4,

"single_deposit_amount" NUMERIC(20,2),

"effective_amount" NUMERIC(20,2),

"bet_count" int4

);



COMMENT ON TABLE "activity_money_condition" IS '优惠时间段 -- bruce';



COMMENT ON COLUMN "activity_money_condition"."id" IS '主键';



COMMENT ON COLUMN "activity_money_condition"."activity_message_id" IS '活动id';



COMMENT ON COLUMN "activity_money_condition"."single_deposit_amount" IS '单次存款金额';



COMMENT ON COLUMN "activity_money_condition"."effective_amount" IS '有效交易量';



COMMENT ON COLUMN "activity_money_condition"."bet_count" IS '抽奖次数';
