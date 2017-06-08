-- auto gen by cherry 2017-06-08 16:35:45
select redo_sqls($$
       ALTER TABLE activity_money_awards_rules ADD COLUMN remain_count int4 DEFAULT 0;
$$);


COMMENT ON COLUMN activity_money_awards_rules.remain_count IS '剩余次数';


CREATE TABLE IF NOT EXISTS "activity_money_play_record" (
"id" SERIAL4 NOT NULL PRIMARY KEY,
"activity_message_id" int4,
"open_period_id" int4,
"player_id" int4,
"is_default" BOOLEAN,
"is_win" BOOLEAN,
"win_amount" NUMERIC(20,2),
"operate_time" timestamp(6)
);
COMMENT ON TABLE "activity_money_play_record" IS '红包抽奖记录表 -- younger';
COMMENT ON COLUMN "activity_money_play_record"."id" IS '主键';
COMMENT ON COLUMN "activity_money_play_record"."activity_message_id" IS '活动id';
COMMENT ON COLUMN "activity_money_play_record"."open_period_id" IS '开奖时段ID';
COMMENT ON COLUMN "activity_money_play_record"."player_id" IS '玩家ID';
COMMENT ON COLUMN "activity_money_play_record"."is_default" IS '是否内定中奖';
COMMENT ON COLUMN "activity_money_play_record"."is_win" IS '是否中奖';
COMMENT ON COLUMN "activity_money_play_record"."win_amount" IS '中奖金额';
COMMENT ON COLUMN "activity_money_play_record"."operate_time" IS '操作时间';