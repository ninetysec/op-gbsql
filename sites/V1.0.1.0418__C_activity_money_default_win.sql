-- auto gen by cherry 2017-03-30 13:52:54
CREATE TABLE IF NOT EXISTS "activity_money_default_win" (

"id" SERIAL4 NOT NULL PRIMARY KEY,

"activity_message_id" int4,

"activity_money_awards_rules_id" int4,

"amount" NUMERIC(20,2),

"win_count" int4,

"operate_id" int4,

"operate_username" VARCHAR(32),

"operate_time" timestamp(6),

"status" VARCHAR(6)

);



COMMENT ON TABLE "activity_money_default_win" IS '红包内定表 -- younger';

COMMENT ON COLUMN "activity_money_default_win"."id" IS '主键';

COMMENT ON COLUMN "activity_money_default_win"."activity_message_id" IS '活动id';

COMMENT ON COLUMN "activity_money_default_win"."activity_money_awards_rules_id" IS '奖项ID';

COMMENT ON COLUMN "activity_money_default_win"."amount" IS '中奖金额';

COMMENT ON COLUMN "activity_money_default_win"."win_count" IS '中奖次数';

COMMENT ON COLUMN "activity_money_default_win"."operate_id" IS '操作人ID';

COMMENT ON COLUMN "activity_money_default_win"."operate_username" IS '操作人账号';

COMMENT ON COLUMN "activity_money_default_win"."operate_time" IS '操作时间';

COMMENT ON COLUMN "activity_money_default_win"."status" IS '状态';


CREATE TABLE IF not EXISTS "activity_money_default_win_player" (

"id" SERIAL4 NOT NULL PRIMARY KEY,

"default_win_id" int4,

"player_id" int4,

"username" VARCHAR(32),

"remain_win_count" int4

);

COMMENT ON TABLE "activity_money_default_win_player" IS '红包内定玩家表 -- younger';

COMMENT ON COLUMN "activity_money_default_win_player"."id" IS '主键';

COMMENT ON COLUMN "activity_money_default_win_player"."default_win_id" IS '内定记录表ID';

COMMENT ON COLUMN "activity_money_default_win_player"."player_id" IS '玩家ID';

COMMENT ON COLUMN "activity_money_default_win_player"."username" IS '玩家账号';

COMMENT ON COLUMN "activity_money_default_win_player"."remain_win_count" IS '剩余中奖次数';