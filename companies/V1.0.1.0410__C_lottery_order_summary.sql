-- auto gen by cherry 2017-09-05 10:15:17
CREATE TABLE IF not EXISTS "lottery_order_summary" (
"id" serial4  NOT NULL PRIMARY KEY,

"expect" varchar(32),

"code" varchar(32),

"play_code" varchar(32),

"bet_code" varchar(32),

"bet_num" varchar(32),

"odd" numeric(20,3),

"bet_amount" numeric(20,2),

"payout" numeric(20,2),

"create_time" timestamp(6),

"user_id" int4,

"site_id" int4

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_order_summary" IS '彩票注单汇总表';

COMMENT ON COLUMN "lottery_order_summary"."id" IS '主键';

COMMENT ON COLUMN "lottery_order_summary"."expect" IS '期数';

COMMENT ON COLUMN "lottery_order_summary"."create_time" IS '汇总时间';

COMMENT ON COLUMN "lottery_order_summary"."code" IS '投注彩种';

COMMENT ON COLUMN "lottery_order_summary"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "lottery_order_summary"."bet_code" IS '投注玩法';

COMMENT ON COLUMN "lottery_order_summary"."bet_num" IS '投注号码,多个号码逗号隔开';

COMMENT ON COLUMN "lottery_order_summary"."odd" IS '赔率';

COMMENT ON COLUMN "lottery_order_summary"."bet_amount" IS '投注金额';

COMMENT ON COLUMN "lottery_order_summary"."payout" IS '派彩金额';

COMMENT ON COLUMN "lottery_order_summary"."user_id" IS '玩家ID';

COMMENT ON COLUMN "lottery_order_summary"."site_id" IS '站点ID';

CREATE INDEX if NOT EXISTS fk_lottery_order_summary_code_expect ON lottery_order_summary USING btree (code,expect);
CREATE INDEX if NOT EXISTS fk_lottery_order_summary_site_id ON lottery_order_summary USING btree (site_id);

CREATE TABLE IF not EXISTS "lottery_result_kill" (
"id" serial4  NOT NULL PRIMARY KEY,

"expect" varchar(32),

"code" varchar(32),

"open_code" varchar(32),

"kill_percent" numeric(20,2),

"profit_percent" numeric(20,2),

"bet_amount" numeric(20,2),

"payout" numeric(20,2),

"max_calculate_times" int4,

"actual_calculate_times" int4,

"status" varchar(2) ,

"remark" text,

"create_time" timestamp(6)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_result_kill" IS '彩票开奖结果杀率表';

COMMENT ON COLUMN "lottery_result_kill"."id" IS '主键';

COMMENT ON COLUMN "lottery_result_kill"."expect" IS '期数';

COMMENT ON COLUMN "lottery_result_kill"."create_time" IS '入库时间';

COMMENT ON COLUMN "lottery_result_kill"."code" IS '投注彩种';

COMMENT ON COLUMN "lottery_result_kill"."open_code" IS '开奖号码,多个号码逗号隔开';

COMMENT ON COLUMN "lottery_result_kill"."max_calculate_times" IS '最大计算次数';

COMMENT ON COLUMN "lottery_result_kill"."actual_calculate_times" IS '实际计算次数';

COMMENT ON COLUMN "lottery_result_kill"."bet_amount" IS '投注金额';

COMMENT ON COLUMN "lottery_result_kill"."payout" IS '派彩金额';

COMMENT ON COLUMN "lottery_result_kill"."profit_percent" IS '盈利百分比';

COMMENT ON COLUMN "lottery_result_kill"."kill_percent" IS '杀率百分比';

COMMENT ON COLUMN "lottery_result_kill"."status" IS '状态';

COMMENT ON COLUMN "lottery_result_kill"."remark" IS '备注';

CREATE INDEX if NOT EXISTS fk_lottery_result_kill_code_expect ON lottery_result_kill USING btree (code,expect);

CREATE TABLE IF not EXISTS "lottery_summery_record" (
"id" serial4 NOT NULL PRIMARY KEY,
"site_id" int4,
"expect" varchar(32) ,
"code" varchar(32) ,
"create_time" timestamp(6),
"status" varchar(2) ,
"remark" text
);

COMMENT ON TABLE "lottery_summery_record" IS '彩票汇总记录表';

COMMENT ON COLUMN "lottery_summery_record"."id" IS '主键';

COMMENT ON COLUMN "lottery_summery_record"."site_id" IS '站点ID';

COMMENT ON COLUMN "lottery_summery_record"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_summery_record"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_summery_record"."create_time" IS '入库时间';

COMMENT ON COLUMN "lottery_summery_record"."status" IS '状态';

COMMENT ON COLUMN "lottery_summery_record"."remark" IS '备注';


