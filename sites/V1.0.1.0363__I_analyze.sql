CREATE TABLE IF NOT EXISTS analyze_agent (
"id" serial4  NOT NULL,
"agent_id" int4,
"agent_name" varchar(32) COLLATE "default",
"topagent_id" int4,
"topagent_name" varchar(32) COLLATE "default",
"new_player_num" int4,
"new_player_num_deposit" int4,
"new_player_num_withdraw" int4,
"new_player_deposit_count" int4,
"new_player_withdraw_count" int4,
"new_player_deposit_amount" numeric(20,2),
"new_player_withdraw_amount" numeric(20,2),
"player_num_deposit" int4,
"player_num_withdraw" int4,
"deposit_amount" numeric(20,2),
"withdraw_amount" numeric(20,2),
"transaction_order" numeric(20,2),
"transaction_volume" numeric(20,2),
"effective_amount" numeric(20,2),
"rebate_amount" numeric(20,2),
"payout_amount" numeric(20,2),
"static_date" date,
"static_time" timestamp(6),
"static_time_end" timestamp(6),
CONSTRAINT "analyze_agent_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE analyze_agent IS '代理分析';

COMMENT ON COLUMN analyze_agent."id" IS '主键';

COMMENT ON COLUMN analyze_agent."agent_id" IS '代理ID';

COMMENT ON COLUMN analyze_agent."agent_name" IS '代理账号';

COMMENT ON COLUMN analyze_agent."topagent_id" IS '总代ID';

COMMENT ON COLUMN analyze_agent."topagent_name" IS '总代账号';

COMMENT ON COLUMN analyze_agent."new_player_num" IS '当天新玩家数';

COMMENT ON COLUMN analyze_agent."new_player_num_deposit" IS '当天新玩家的存款人数';

COMMENT ON COLUMN analyze_agent."new_player_num_withdraw" IS '当天新玩家的取款人数';

COMMENT ON COLUMN analyze_agent."new_player_deposit_count" IS '当天新玩家的存款次数';

COMMENT ON COLUMN analyze_agent."new_player_withdraw_count" IS '当天新玩家的取款次数';

COMMENT ON COLUMN analyze_agent."new_player_deposit_amount" IS '当天新玩家的存款总额';

COMMENT ON COLUMN analyze_agent."new_player_withdraw_amount" IS '当天新玩家的取款总额';

COMMENT ON COLUMN analyze_agent."player_num_deposit" IS '当天存款人数';

COMMENT ON COLUMN analyze_agent."player_num_withdraw" IS '当天取款人数';

COMMENT ON COLUMN analyze_agent."deposit_amount" IS '当天存款总额';

COMMENT ON COLUMN analyze_agent."withdraw_amount" IS '主当天取款总额';

COMMENT ON COLUMN analyze_agent."transaction_order" IS '当天交易单量';

COMMENT ON COLUMN analyze_agent."transaction_volume" IS '当天投注单量';

COMMENT ON COLUMN analyze_agent."effective_amount" IS '当天有效交易量';

COMMENT ON COLUMN analyze_agent."rebate_amount" IS '当天返佣金额';

COMMENT ON COLUMN analyze_agent."payout_amount" IS '当日损益（派彩）';

COMMENT ON COLUMN analyze_agent."static_date" IS '统计日期';

COMMENT ON COLUMN analyze_agent."static_time" IS '统计起始时间';

COMMENT ON COLUMN analyze_agent."static_time_end" IS '统计结束时间';





CREATE TABLE IF NOT EXISTS analyze_agent_domain (
"id" serial4 NOT NULL,
"promote_link" varchar(256) COLLATE "default",
"agent_id" int4,
"agent_name" varchar(32) COLLATE "default",
"topagent_id" int4,
"topagent_name" varchar(32) COLLATE "default",
"new_player_num" int4,
"new_player_num_deposit" int4,
"new_player_num_withdraw" int4,
"new_player_deposit_count" int4,
"new_player_withdraw_count" int4,
"new_player_deposit_amount" numeric(20,2),
"new_player_withdraw_amount" numeric(20,2),
"player_num_deposit" int4,
"player_num_withdraw" int4,
"deposit_amount" numeric(20,2),
"withdraw_amount" numeric(20,2),
"transaction_order" numeric(20,2),
"transaction_volume" numeric(20,2),
"effective_amount" numeric(20,2),
"rebate_amount" numeric(20,2),
"payout_amount" numeric(20,2),
"static_date" date,
"static_time" timestamp(6),
"static_time_end" timestamp(6),
CONSTRAINT "analyze_agent_domain_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE analyze_agent_domain IS '代理分析';

COMMENT ON COLUMN analyze_agent_domain."id" IS '主键';

COMMENT ON COLUMN analyze_agent_domain."promote_link" IS '推广链接';

COMMENT ON COLUMN analyze_agent_domain."agent_id" IS '代理ID';

COMMENT ON COLUMN analyze_agent_domain."agent_name" IS '代理账号';

COMMENT ON COLUMN analyze_agent_domain."topagent_id" IS '总代ID';

COMMENT ON COLUMN analyze_agent_domain."topagent_name" IS '总代账号';

COMMENT ON COLUMN analyze_agent_domain."new_player_num" IS '当天新玩家数';

COMMENT ON COLUMN analyze_agent_domain."new_player_num_deposit" IS '当天新玩家的存款人数';

COMMENT ON COLUMN analyze_agent_domain."new_player_num_withdraw" IS '当天新玩家的取款人数';

COMMENT ON COLUMN analyze_agent_domain."new_player_deposit_count" IS '当天新玩家的存款次数';

COMMENT ON COLUMN analyze_agent_domain."new_player_withdraw_count" IS '当天新玩家的取款次数';

COMMENT ON COLUMN analyze_agent_domain."new_player_deposit_amount" IS '当天新玩家的存款总额';

COMMENT ON COLUMN analyze_agent_domain."new_player_withdraw_amount" IS '当天新玩家的取款总额';

COMMENT ON COLUMN analyze_agent_domain."player_num_deposit" IS '当天存款人数';

COMMENT ON COLUMN analyze_agent_domain."player_num_withdraw" IS '当天取款人数';

COMMENT ON COLUMN analyze_agent_domain."deposit_amount" IS '当天存款总额';

COMMENT ON COLUMN analyze_agent_domain."withdraw_amount" IS '主当天取款总额';

COMMENT ON COLUMN analyze_agent_domain."transaction_order" IS '当天交易单量';

COMMENT ON COLUMN analyze_agent_domain."transaction_volume" IS '当天投注单量';

COMMENT ON COLUMN analyze_agent_domain."effective_amount" IS '当天有效交易量';

COMMENT ON COLUMN analyze_agent_domain."rebate_amount" IS '当天返佣金额';

COMMENT ON COLUMN analyze_agent_domain."payout_amount" IS '当日损益（派彩）';

COMMENT ON COLUMN analyze_agent_domain."static_date" IS '统计日期';

COMMENT ON COLUMN analyze_agent_domain."static_time" IS '统计起始时间';

COMMENT ON COLUMN analyze_agent_domain."static_time_end" IS '统计结束时间';





  select redo_sqls($$
       ALTER TABLE analyze_player ADD COLUMN user_name VARCHAR (32) ;
       ALTER TABLE analyze_player ADD COLUMN agent_name VARCHAR (32) ;
       ALTER TABLE analyze_player ADD COLUMN topagent_name VARCHAR (32) ;
       ALTER TABLE analyze_player ADD COLUMN deposit_count int4;
       ALTER TABLE analyze_player ADD COLUMN withdraw_count int4;
       ALTER TABLE analyze_player ADD COLUMN transaction_order NUMERIC (20, 2);
       ALTER TABLE analyze_player ADD COLUMN transaction_volume NUMERIC (20, 2);
       COMMENT ON COLUMN analyze_player."user_name" IS '代理账号';

      COMMENT ON COLUMN analyze_player."agent_name" IS '代理账号';

      COMMENT ON COLUMN analyze_player."topagent_name" IS '总代账号';

      COMMENT ON COLUMN analyze_player."deposit_count" IS '当天存款次数';

      COMMENT ON COLUMN analyze_player."withdraw_count" IS '当天取款次数';

      COMMENT ON COLUMN analyze_player."transaction_order" IS '主当天交易单量';

      COMMENT ON COLUMN analyze_player."transaction_volume" IS '当天交易量';
  $$);