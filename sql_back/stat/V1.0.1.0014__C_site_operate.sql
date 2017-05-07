-- auto gen by cheery 2015-11-30 06:10:57
-- 站点经营报表 --
CREATE TABLE IF NOT EXISTS site_operate (
  id 					serial4 NOT NULL,
  site_id 			int4,
  site_name 			varchar(100),
  center_id 			int4,
  center_name 		varchar(100),
  master_id 			int4,
  master_name 		varchar(100),
  player_num 			int4,
  api_id 				int4,
  game_type_parent 	varchar(32),
  game_type 			varchar(32),
  static_time 		timestamp(6),
  create_time 		timestamp(6),
  transaction_order 		numeric(20,2) DEFAULT 0,
  transaction_volume 		numeric(20,2) DEFAULT 0,
  effective_transaction	numeric(20,2) DEFAULT 0,
  profit_loss 			numeric(20,2) DEFAULT 0,
  agent_num INT4,
  top_agent_num INT4,
  CONSTRAINT site_operate_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

ALTER TABLE site_operate OWNER TO postgres;
COMMENT ON TABLE site_operate IS '站点经营报表 - Fly';
COMMENT ON COLUMN site_operate.site_id IS '站点ID';
COMMENT ON COLUMN site_operate.site_name IS '站点名称';
COMMENT ON COLUMN site_operate.center_id IS '运营商ID';
COMMENT ON COLUMN site_operate.center_name IS '运营商名称';
COMMENT ON COLUMN site_operate.master_id IS '站长ID';
COMMENT ON COLUMN site_operate.master_name IS '站长名称';
COMMENT ON COLUMN site_operate.player_num IS '玩家数量';
COMMENT ON COLUMN site_operate.api_id IS 'api外键';
COMMENT ON COLUMN site_operate.game_type_parent IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN site_operate.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN site_operate.static_time IS '统计时间';
COMMENT ON COLUMN site_operate.create_time IS '创建时间';
COMMENT ON COLUMN site_operate.transaction_order IS '交易单量';
COMMENT ON COLUMN site_operate.transaction_volume IS '交易量';
COMMENT ON COLUMN site_operate.effective_transaction IS '有效交易量';
COMMENT ON COLUMN site_operate.profit_loss IS '交易盈亏';
COMMENT ON COLUMN site_operate.agent_num IS '代理数量';
COMMENT ON COLUMN site_operate.top_agent_num IS '总代理数量';