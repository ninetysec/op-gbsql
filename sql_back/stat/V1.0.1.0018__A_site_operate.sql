-- auto gen by cheery 2015-12-10 10:13:57
select redo_sqls($$
   ALTER TABLE site_operate ADD COLUMN site_num integer NULL;
ALTER TABLE site_operate  ADD COLUMN api_type_id int4;
  $$);

COMMENT ON COLUMN site_operate.site_num IS '站点数量';
COMMENT ON COLUMN site_operate.api_type_id IS 'api_type表ID';

-- 删除game_type_parent,新增api_type_id
ALTER TABLE site_operate DROP COLUMN IF EXISTS game_type_parent;

-- 站长经营报表 --
CREATE TABLE IF NOT EXISTS master_operate (
	id 					serial4 NOT NULL,
	site_id 			int4,
	site_name 			varchar(100),
	center_id 			int4,
	center_name 		varchar(100),
	master_id 			int4,
	master_name 		varchar(100),
	master_num			int4,
	site_num			int4,
	top_agent_num		int4,
	agent_num			int4,
	player_num 			int4,
	api_id 				int4,
	api_type_id 	varchar(32),
	game_type 			varchar(32),
	static_time 		timestamp(6),
	create_time 		timestamp(6),
	transaction_order 		numeric(20,2) DEFAULT 0,
	transaction_volume 		numeric(20,2) DEFAULT 0,
	effective_transaction	numeric(20,2) DEFAULT 0,
	profit_loss 			numeric(20,2) DEFAULT 0,
	CONSTRAINT master_operate_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

ALTER TABLE master_operate OWNER TO postgres;
COMMENT ON TABLE master_operate IS '站长经营报表 - Fly';
COMMENT ON COLUMN master_operate.site_id IS '站点ID';
COMMENT ON COLUMN master_operate.site_name IS '站点名称';
COMMENT ON COLUMN master_operate.center_id IS '运营商ID';
COMMENT ON COLUMN master_operate.center_name IS '运营商名称';
COMMENT ON COLUMN master_operate.master_id IS '站长ID';
COMMENT ON COLUMN master_operate.master_name IS '站长名称';
COMMENT ON COLUMN master_operate.site_num IS '站长数量';
COMMENT ON COLUMN master_operate.master_num IS '站点数量';
COMMENT ON COLUMN master_operate.top_agent_num IS '总代数量';
COMMENT ON COLUMN master_operate.agent_num IS '代理数量';
COMMENT ON COLUMN master_operate.player_num IS '玩家数量';
COMMENT ON COLUMN master_operate.api_id IS 'api外键';
COMMENT ON COLUMN master_operate.api_type_id IS 'api_type表ID';
COMMENT ON COLUMN master_operate.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN master_operate.static_time IS '统计时间';
COMMENT ON COLUMN master_operate.create_time IS '创建时间';
COMMENT ON COLUMN master_operate.transaction_order IS '交易单量';
COMMENT ON COLUMN master_operate.transaction_volume IS '交易量';
COMMENT ON COLUMN master_operate.effective_transaction IS '有效交易量';
COMMENT ON COLUMN master_operate.profit_loss IS '交易盈亏';

-- 删除已废除的站点经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_site;
-- 删除已废除的总代经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_top_agent;
-- 删除已废除的代理经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_agent;
-- 删除已废除的玩家经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_players;