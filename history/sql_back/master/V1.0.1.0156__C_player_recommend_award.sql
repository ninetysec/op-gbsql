-- auto gen by cheery 2015-10-30 18:00:16
--创建推荐玩家记录表
CREATE TABLE IF NOT EXISTS player_recommend_award(
  id SERIAL4 NOT NULL ,
  player_transaction_id INT4,
  transaction_no varchar(32),
  user_id INT4,
  user_name varchar(32),
  recommend_user_id INT4,
  recommend_user_name varchar(32),
  reward_mode varchar(32),
  reward_amount numeric(20,2),
  reward_time timestamp(6),
  CONSTRAINT "player_recommend_award_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "player_recommend_award" OWNER TO "postgres";

COMMENT ON TABLE "player_recommend_award" IS '推荐记录表-susu';
COMMENT ON COLUMN player_recommend_award.id IS '主键id';
COMMENT ON COLUMN player_recommend_award.player_transaction_id IS '交易表对应id';
COMMENT ON COLUMN player_recommend_award.transaction_no IS '交易号';
COMMENT ON COLUMN player_recommend_award.user_id IS '推荐人ID';
COMMENT ON COLUMN player_recommend_award.user_name IS '推荐人账号';
COMMENT ON COLUMN player_recommend_award.recommend_user_id IS '被推荐人ID';
COMMENT ON COLUMN player_recommend_award.recommend_user_name IS '被推荐人账号';
COMMENT ON COLUMN player_recommend_award.reward_mode IS '奖励方式recommend.reward_mode(单次奖励,红利奖励)';
COMMENT ON COLUMN player_recommend_award.reward_amount IS '奖励金额';
COMMENT ON COLUMN player_recommend_award.reward_time IS '奖励时间';

--修改活动类型字段
UPDATE activity_type SET code = 'deposit_send' WHERE code = (SELECT code FROM activity_type WHERE  code= 'deposit');

--添加咨询表状态字段
select redo_sqls($$
  ALTER TABLE "player_advisory" ADD COLUMN "status" bool;
$$);

COMMENT ON COLUMN "player_advisory"."status" IS '逻辑删除用到的状态';
