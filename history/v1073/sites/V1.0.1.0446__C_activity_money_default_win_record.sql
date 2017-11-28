-- auto gen by cherry 2017-05-26 10:58:22
CREATE TABLE if not EXISTS "activity_money_default_win_record" (

"id" serial4 NOT NULL PRIMARY KEY,

"activity_message_id" int4,

"operate_user_id" int4,

operate_username VARCHAR(32),

operate_type VARCHAR(2),

operate_time TIMESTAMP(6),

default_win_id int4,

operate_orgin VARCHAR(2)

);

COMMENT ON TABLE "activity_money_default_win_record" IS '红包内定操作记录表 -- younger';

COMMENT ON COLUMN "activity_money_default_win_record"."id" IS '主键';

COMMENT ON COLUMN "activity_money_default_win_record"."activity_message_id" IS '活动ID';

COMMENT ON COLUMN "activity_money_default_win_record"."operate_user_id" IS '操作人ID';

COMMENT ON COLUMN "activity_money_default_win_record"."operate_username" IS '操作人账号';

COMMENT ON COLUMN "activity_money_default_win_record"."operate_type" IS '操作类型：1,设定2,取消设定';

COMMENT ON COLUMN "activity_money_default_win_record"."operate_time" IS '操作时间';

COMMENT ON COLUMN "activity_money_default_win_record"."default_win_id" IS '内定记录表ID';

COMMENT ON COLUMN "activity_money_default_win_record"."operate_orgin" IS '操作来源:1,人为2,系统';