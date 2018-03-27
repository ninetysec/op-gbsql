-- auto gen by linsen 2018-01-28 10:10:34
CREATE TABLE IF NOT EXISTS "api_collate_site" (
"id" serial4,
"site_id" int4,
"site_name" varchar(100) COLLATE "default",
"center_id" int4,
"center_name" varchar(100) COLLATE "default",
"master_id" int4,
"master_name" varchar(100) COLLATE "default",
"player_num" int4,
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
"winning_amount" numeric(20,2) DEFAULT 0,
"contribution_amount" numeric(20,2) DEFAULT 0,
CONSTRAINT "api_collate_site_pkey" PRIMARY KEY ("id"),
CONSTRAINT "api_collate_site_ssag_uk" UNIQUE ("static_date", "site_id", "api_id", "game_type")
)
;

COMMENT ON COLUMN "api_collate_site"."site_id" IS '站点ID';
COMMENT ON COLUMN "api_collate_site"."site_name" IS '站点名称';
COMMENT ON COLUMN "api_collate_site"."center_id" IS '运营商ID';
COMMENT ON COLUMN "api_collate_site"."center_name" IS '运营商名称';
COMMENT ON COLUMN "api_collate_site"."master_id" IS '站长ID';
COMMENT ON COLUMN "api_collate_site"."master_name" IS '站长名称';
COMMENT ON COLUMN "api_collate_site"."player_num" IS '玩家数量';
COMMENT ON COLUMN "api_collate_site"."api_id" IS 'api外键';
COMMENT ON COLUMN "api_collate_site"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "api_collate_site"."static_time" IS '统计起始时间';
COMMENT ON COLUMN "api_collate_site"."create_time" IS '创建时间';
COMMENT ON COLUMN "api_collate_site"."transaction_order" IS '交易单量';
COMMENT ON COLUMN "api_collate_site"."transaction_volume" IS '交易量';
COMMENT ON COLUMN "api_collate_site"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "api_collate_site"."profit_loss" IS '交易盈亏';
COMMENT ON COLUMN "api_collate_site"."api_type_id" IS 'api_type表ID';
COMMENT ON COLUMN "api_collate_site"."static_date" IS '统计日期';
COMMENT ON COLUMN "api_collate_site"."static_time_end" IS '统计截止时间';
COMMENT ON COLUMN "api_collate_site"."winning_amount" IS '中奖金额';
COMMENT ON COLUMN "api_collate_site"."contribution_amount" IS '彩池共享金';

SELECT redo_sqls($$
CREATE INDEX "api_collate_site_api_id_idx" ON "api_collate_site" USING btree ("api_id");
CREATE INDEX "api_collate_site_api_type_id_idx" ON "api_collate_site" USING btree ("api_type_id");
CREATE INDEX "api_collate_site_center_id_idx" ON "api_collate_site" USING btree ("center_id");
CREATE INDEX "api_collate_site_master_id_idx" ON "api_collate_site" USING btree ("master_id");
CREATE INDEX "api_collate_site_site_id_idx" ON "api_collate_site" USING btree ("site_id");
CREATE INDEX "api_collate_site_static_time_idx" ON "api_collate_site" USING btree ("static_time");
$$);