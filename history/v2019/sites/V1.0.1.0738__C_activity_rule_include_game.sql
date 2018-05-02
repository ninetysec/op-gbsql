-- auto gen by linsen 2018-04-11 19:07:11
-- user_player添加字段 by younger
select redo_sqls($$
    ALTER TABLE "user_player" ADD COLUMN "deposit_send_type" varchar(50) DEFAULT '000';
	  ALTER TABLE "user_player" ADD COLUMN "deposit_send_start_time" TIMESTAMP(6);
$$);
  COMMENT ON COLUMN "user_player"."deposit_send_type" IS '存送类型 （000）（111）,依次为首存、二存、三存送';
  COMMENT ON COLUMN "user_player"."deposit_send_start_time" IS '存送计算开始时间';

-- 创建活动规则包含游戏表 by younger
CREATE TABLE IF NOT EXISTS "activity_rule_include_game" (
"id" serial4  NOT NULL PRIMARY KEY,
"activity_message_id" int4,
"api_id" int4,
"game_id" int4,
"api_type_id" int4,
"game_type" varchar(32)
)
WITH (OIDS=FALSE)
;
COMMENT ON TABLE "activity_rule_include_game" IS '活动规则包含游戏表-younger';

COMMENT ON COLUMN "activity_rule_include_game"."id" IS '主键';

COMMENT ON COLUMN "activity_rule_include_game"."activity_message_id" IS '活动信息外键';

COMMENT ON COLUMN "activity_rule_include_game"."api_id" IS 'API ID';

COMMENT ON COLUMN "activity_rule_include_game"."game_id" IS '游戏ID';

COMMENT ON COLUMN "activity_rule_include_game"."api_type_id" IS 'API分类ID';

COMMENT ON COLUMN "activity_rule_include_game"."game_type" IS '游戏二级分类';