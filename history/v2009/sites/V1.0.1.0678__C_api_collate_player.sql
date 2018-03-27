-- auto gen by george 2018-01-28 10:07:21
SELECT redo_sqls($$
ALTER TABLE rebate_agent ADD COLUMN rebate_amount NUMERIC(20, 2);
COMMENT ON COLUMN rebate_agent.rebate_amount IS '本期返佣=自身返佣+下级抽佣<=返佣上限';
ALTER TABLE rebate_agent_nosettled ADD COLUMN rebate_amount NUMERIC(20, 2);
COMMENT ON COLUMN rebate_agent_nosettled.rebate_amount IS '本期返佣=自身返佣+下级抽佣<=返佣上限';
$$);

CREATE TABLE IF NOT EXISTS "api_collate_player" (
"id" serial4 ,
"center_id" int4 NOT NULL,
"center_name" varchar(100) COLLATE "default",
"site_id" int4,
"site_name" varchar(100) COLLATE "default",
"master_id" int4,
"master_name" varchar(100) COLLATE "default",
"topagent_id" int4,
"topagent_name" varchar(32) COLLATE "default",
"agent_id" int4,
"agent_name" varchar(32) COLLATE "default",
"player_id" int4,
"player_name" varchar(32) COLLATE "default",
"api_id" int4,
"game_type" varchar(32) COLLATE "default",
"static_time" timestamp(6),
"create_time" timestamp(6),
"transaction_order" numeric(20,2) DEFAULT 0,
"transaction_volume" numeric(20,2) DEFAULT 0,
"effective_transaction" numeric(20,2) DEFAULT 0,
"profit_loss" numeric(20,2) DEFAULT 0,
"api_type_id" int4,
"static_date" date,
"static_time_end" timestamp(6),
"winning_amount" numeric(20,2),
"contribution_amount" numeric(20,2),
CONSTRAINT "api_collate_player_pkey" PRIMARY KEY ("id"),
CONSTRAINT "api_collate_player_spag_uk" UNIQUE (static_date, player_id, api_id, game_type)
)
;

COMMENT ON COLUMN "api_collate_player"."center_id" IS '运营商ID';
COMMENT ON COLUMN "api_collate_player"."center_name" IS '运营商名称';
COMMENT ON COLUMN "api_collate_player"."site_id" IS '站点ID';
COMMENT ON COLUMN "api_collate_player"."site_name" IS '站点名称';
COMMENT ON COLUMN "api_collate_player"."master_id" IS '站长ID';
COMMENT ON COLUMN "api_collate_player"."master_name" IS '站长名称';
COMMENT ON COLUMN "api_collate_player"."topagent_id" IS '总代ID';
COMMENT ON COLUMN "api_collate_player"."topagent_name" IS '总代账号';
COMMENT ON COLUMN "api_collate_player"."agent_id" IS '代理ID';
COMMENT ON COLUMN "api_collate_player"."agent_name" IS '代理账号';
COMMENT ON COLUMN "api_collate_player"."player_id" IS '玩家ID';
COMMENT ON COLUMN "api_collate_player"."player_name" IS '玩家账号';
COMMENT ON COLUMN "api_collate_player"."api_id" IS 'api外键';
COMMENT ON COLUMN "api_collate_player"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "api_collate_player"."static_time" IS '统计起始时间';
COMMENT ON COLUMN "api_collate_player"."create_time" IS '创建时间';
COMMENT ON COLUMN "api_collate_player"."transaction_order" IS '交易单量';
COMMENT ON COLUMN "api_collate_player"."transaction_volume" IS '交易量';
COMMENT ON COLUMN "api_collate_player"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "api_collate_player"."profit_loss" IS '交易盈亏';
COMMENT ON COLUMN "api_collate_player"."api_type_id" IS 'api_type表ID';
COMMENT ON COLUMN "api_collate_player"."static_date" IS '统计日期';
COMMENT ON COLUMN "api_collate_player"."static_time_end" IS '统计截止时间';
COMMENT ON COLUMN "api_collate_player"."winning_amount" IS '中奖金额';
COMMENT ON COLUMN "api_collate_player"."contribution_amount" IS '彩池共享金';

SELECT redo_sqls($$
CREATE INDEX "api_collate_player_center_id_idx" ON "api_collate_player" USING btree ("center_id");
CREATE INDEX "api_collate_player_master_id_idx" ON "api_collate_player" USING btree ("master_id");
CREATE INDEX "api_collate_player_site_id_idx" ON "api_collate_player" USING btree ("site_id");
CREATE INDEX "api_collate_player_topagent_id_idx" ON "api_collate_player" USING btree ("topagent_id");
CREATE INDEX "api_collate_player_agent_id_idx" ON "api_collate_player" USING btree ("agent_id");
CREATE INDEX "api_collate_player_api_id_idx" ON "api_collate_player" USING btree ("api_id");
CREATE INDEX "api_collate_player_api_type_id_idx" ON "api_collate_player" USING btree ("api_type_id");
CREATE INDEX "api_collate_player_player_id_idx" ON "api_collate_player" USING btree ("player_id");
CREATE INDEX "api_collate_player_static_time_idx" ON "api_collate_player" USING btree ("static_time");
$$);