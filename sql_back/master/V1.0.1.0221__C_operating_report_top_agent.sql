-- auto gen by cheery 2015-11-24 01:56:15
-- 总代经营报表 --
CREATE TABLE IF NOT EXISTS operating_report_top_agent (
  "id" SERIAL4 NOT NULL,
  "center_id" int4 NOT NULL,
  "center_name" varchar(100) COLLATE "default",
  "site_id" INT4,
  "site_name" varchar(100) COLLATE "default",
  "master_id" int4,
  "master_name" varchar(100) COLLATE "default",
  "top_agent_id" INT4,
  "top_agent_name" varchar(32) COLLATE "default",
  "players_num" INT4,
  "api_id" INT4,
  "game_type_parent" varchar(32) COLLATE "default",
  "game_type" varchar(32) COLLATE "default",
  "statistical_date" timestamp(6),
  "create_time" timestamp(6),
  "transaction_order" numeric(20,2) DEFAULT 0,
  "transaction_volume" numeric(20,2) DEFAULT 0,
  "effective_transaction_volume" numeric(20,2) DEFAULT 0,
  "transaction_profit_loss" numeric(20,2) DEFAULT 0,
  CONSTRAINT "operating_report_top_agent_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE);

ALTER TABLE "operating_report_top_agent" OWNER TO "postgres";
COMMENT ON TABLE "operating_report_top_agent" IS '总代经营报表 - Fly';
COMMENT ON COLUMN "operating_report_top_agent"."center_id" IS '运营商ID';
COMMENT ON COLUMN "operating_report_top_agent"."center_name" IS '运营商名称';
COMMENT ON COLUMN "operating_report_top_agent"."site_id" IS '站点ID';
COMMENT ON COLUMN "operating_report_top_agent"."site_name" IS '站点名称';
COMMENT ON COLUMN "operating_report_top_agent"."master_id" IS '站长ID';
COMMENT ON COLUMN "operating_report_top_agent"."master_name" IS '站长名称';
COMMENT ON COLUMN "operating_report_top_agent"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "operating_report_top_agent"."top_agent_name" IS '总代账号';
COMMENT ON COLUMN "operating_report_top_agent"."players_num" IS '玩家数量';
COMMENT ON COLUMN "operating_report_top_agent"."api_id" IS 'api外键';
COMMENT ON COLUMN "operating_report_top_agent"."game_type_parent" IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN "operating_report_top_agent"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "operating_report_top_agent"."statistical_date" IS '统计日期';
COMMENT ON COLUMN "operating_report_top_agent"."create_time" IS '创建时间';
COMMENT ON COLUMN "operating_report_top_agent"."transaction_order" IS '当天交易单量';
COMMENT ON COLUMN "operating_report_top_agent"."transaction_volume" IS '当天交易量';
COMMENT ON COLUMN "operating_report_top_agent"."effective_transaction_volume" IS '当天有效交易量';
COMMENT ON COLUMN "operating_report_top_agent"."transaction_profit_loss" IS '当天交易盈亏';

-- 代理经营报表 --
CREATE TABLE IF NOT EXISTS operating_report_agent (
  "id" SERIAL4 NOT NULL,
  "center_id" INT4 NOT NULL,
  "center_name" varchar(100) COLLATE "default",
  "site_id" INT4,
  "site_name" varchar(100) COLLATE "default",
  "master_id" int4,
  "master_name" varchar(100) COLLATE "default",
  "top_agent_id" INT4,
  "top_agent_name" varchar(32) COLLATE "default",
  "agent_id" INT4,
  "agent_name" varchar(32) COLLATE "default",
  "players_num" INT4,
  "api_id" INT4,
  "game_type_parent" varchar(32) COLLATE "default",
  "game_type" varchar(32) COLLATE "default",
  "statistical_date" timestamp(6),
  "create_time" timestamp(6),
  "transaction_order" numeric(20,2) DEFAULT 0,
  "transaction_volume" numeric(20,2) DEFAULT 0,
  "effective_transaction_volume" numeric(20,2) DEFAULT 0,
  "transaction_profit_loss" numeric(20,2) DEFAULT 0,
  CONSTRAINT "operating_report_agent_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE);

ALTER TABLE "operating_report_agent" OWNER TO "postgres";
COMMENT ON TABLE "operating_report_agent" IS '代理经营报表 - Fly';
COMMENT ON COLUMN "operating_report_agent"."center_id" IS '运营商ID';
COMMENT ON COLUMN "operating_report_agent"."center_name" IS '运营商名称';
COMMENT ON COLUMN "operating_report_agent"."site_id" IS '站点ID';
COMMENT ON COLUMN "operating_report_agent"."site_name" IS '站点名称';
COMMENT ON COLUMN "operating_report_agent"."master_id" IS '站长ID';
COMMENT ON COLUMN "operating_report_agent"."master_name" IS '站长名称';
COMMENT ON COLUMN "operating_report_agent"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "operating_report_agent"."top_agent_name" IS '总代账号';
COMMENT ON COLUMN "operating_report_agent"."agent_id" IS '代理ID';
COMMENT ON COLUMN "operating_report_agent"."agent_name" IS '代理账号';
COMMENT ON COLUMN "operating_report_agent"."players_num" IS '玩家数量';
COMMENT ON COLUMN "operating_report_agent"."api_id" IS 'api外键';
COMMENT ON COLUMN "operating_report_agent"."game_type_parent" IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN "operating_report_agent"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "operating_report_agent"."statistical_date" IS '统计日期';
COMMENT ON COLUMN "operating_report_agent"."create_time" IS '创建时间';
COMMENT ON COLUMN "operating_report_agent"."transaction_order" IS '当天交易单量';
COMMENT ON COLUMN "operating_report_agent"."transaction_volume" IS '当天交易量';
COMMENT ON COLUMN "operating_report_agent"."effective_transaction_volume" IS '当天有效交易量';
COMMENT ON COLUMN "operating_report_agent"."transaction_profit_loss" IS '当天交易盈亏';

-- 玩家经营报表 --
CREATE TABLE IF NOT EXISTS operating_report_players (
  "id" SERIAL4 NOT NULL,
  "center_id" INT4 NOT NULL,
  "center_name" varchar(100) COLLATE "default",
  "site_id" INT4,
  "site_name" varchar(100) COLLATE "default",
  "master_id" INT4,
  "master_name" varchar(100) COLLATE "default",
  "top_agent_id" INT4,
  "top_agent_name" varchar(32) COLLATE "default",
  "agent_id" INT4,
  "agent_name" varchar(32) COLLATE "default",
  "user_id" INT4,
  "user_name" varchar(32) COLLATE "default",
  "api_id" INT4,
  "game_type_parent" varchar(32) COLLATE "default",
  "game_type" varchar(32) COLLATE "default",
  "statistical_date" timestamp(6),
  "create_time" timestamp(6),
  "transaction_order" numeric(20,2) DEFAULT 0,
  "transaction_volume" numeric(20,2) DEFAULT 0,
  "effective_transaction_volume" numeric(20,2) DEFAULT 0,
  "transaction_profit_loss" numeric(20,2) DEFAULT 0,
  CONSTRAINT "operating _report_players _pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE);

ALTER TABLE "operating_report_players" OWNER TO "postgres";
COMMENT ON TABLE "operating_report_players" IS '玩家经营报表 - Fly';
COMMENT ON COLUMN "operating_report_players"."center_id" IS '运营商ID';
COMMENT ON COLUMN "operating_report_players"."center_name" IS '运营商名称';
COMMENT ON COLUMN "operating_report_players"."site_id" IS '站点ID';
COMMENT ON COLUMN "operating_report_players"."site_name" IS '站点名称';
COMMENT ON COLUMN "operating_report_players"."master_id" IS '站长ID';
COMMENT ON COLUMN "operating_report_players"."master_name" IS '站长名称';
COMMENT ON COLUMN "operating_report_players"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "operating_report_players"."top_agent_name" IS '总代账号';
COMMENT ON COLUMN "operating_report_players"."agent_id" IS '代理ID';
COMMENT ON COLUMN "operating_report_players"."agent_name" IS '代理账号';
COMMENT ON COLUMN "operating_report_players"."user_id" IS '玩家ID';
COMMENT ON COLUMN "operating_report_players"."user_name" IS '玩家账号';
COMMENT ON COLUMN "operating_report_players"."api_id" IS 'api外键';
COMMENT ON COLUMN "operating_report_players"."game_type_parent" IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN "operating_report_players"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "operating_report_players"."statistical_date" IS '统计日期';
COMMENT ON COLUMN "operating_report_players"."create_time" IS '创建时间';
COMMENT ON COLUMN "operating_report_players"."transaction_order" IS '当天交易单量';
COMMENT ON COLUMN "operating_report_players"."transaction_volume" IS '当天交易量';
COMMENT ON COLUMN "operating_report_players"."effective_transaction_volume" IS '当天有效交易量';
COMMENT ON COLUMN "operating_report_players"."transaction_profit_loss" IS '当天交易盈亏';