-- auto gen by cheery 2015-11-30 06:07:36
-- 总代经营报表 --byFly
CREATE TABLE IF NOT EXISTS operate_topagent (
  id 					serial4 NOT NULL,
  center_id 			int4 NOT NULL,
  center_name 		varchar(100),
  site_id 			int4,
  site_name 			varchar(100),
  master_id 			int4,
  master_name 		varchar(100),
  topagent_id 		int4,
  topagent_name 		varchar(32),
  player_num 			int4,
  api_id 				int4,
  game_type_parent 	varchar(32),
  game_type 			varchar(32),
  static_time 		timestamp(6),
  create_time 		timestamp(6),
  transaction_order 		numeric(20,2) DEFAULT 0,
  transaction_volume 		numeric(20,2) DEFAULT 0,
  effective_transaction 	numeric(20,2) DEFAULT 0,
  profit_loss 			numeric(20,2) DEFAULT 0,
  agent_num INT4,
  CONSTRAINT operate_topagent_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

ALTER TABLE operate_topagent OWNER TO postgres;
COMMENT ON TABLE operate_topagent IS '总代经营报表 - Fly';
COMMENT ON COLUMN operate_topagent.center_id IS '运营商ID';
COMMENT ON COLUMN operate_topagent.center_name IS '运营商名称';
COMMENT ON COLUMN operate_topagent.site_id IS '站点ID';
COMMENT ON COLUMN operate_topagent.site_name IS '站点名称';
COMMENT ON COLUMN operate_topagent.master_id IS '站长ID';
COMMENT ON COLUMN operate_topagent.master_name IS '站长名称';
COMMENT ON COLUMN operate_topagent.topagent_id IS '总代ID';
COMMENT ON COLUMN operate_topagent.topagent_name IS '总代账号';
COMMENT ON COLUMN operate_topagent.player_num IS '玩家数量';
COMMENT ON COLUMN operate_topagent.api_id IS 'api外键';
COMMENT ON COLUMN operate_topagent.game_type_parent IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN operate_topagent.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN operate_topagent.static_time IS '统计时间';
COMMENT ON COLUMN operate_topagent.create_time IS '创建时间';
COMMENT ON COLUMN operate_topagent.transaction_order IS '交易单量';
COMMENT ON COLUMN operate_topagent.transaction_volume IS '交易量';
COMMENT ON COLUMN operate_topagent.effective_transaction IS '有效交易量';
COMMENT ON COLUMN operate_topagent.profit_loss IS '交易盈亏';
COMMENT ON COLUMN operate_topagent.agent_num IS '代理数量';

-- 代理经营报表 --
CREATE TABLE IF NOT EXISTS operate_agent (
  id 					serial4 NOT NULL,
  center_id 			int4 NOT NULL,
  center_name 		varchar(100),
  site_id 			int4,
  site_name 			varchar(100),
  master_id 			int4,
  master_name 		varchar(100),
  topagent_id 		int4,
  topagent_name 		varchar(32),
  agent_id 			int4,
  agent_name 			varchar(32),
  player_num 			int4,
  api_id 				int4,
  game_type_parent 	varchar(32),
  game_type 			varchar(32),
  static_time 		timestamp(6),
  create_time 		timestamp(6),
  transaction_order 		numeric(20,2) DEFAULT 0,
  transaction_volume 		numeric(20,2) DEFAULT 0,
  effective_transaction 	numeric(20,2) DEFAULT 0,
  profit_loss 			numeric(20,2) DEFAULT 0,
  CONSTRAINT operate_agent_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

ALTER TABLE operate_agent OWNER TO postgres;
COMMENT ON TABLE operate_agent IS '代理经营报表 - Fly';
COMMENT ON COLUMN operate_agent.center_id IS '运营商ID';
COMMENT ON COLUMN operate_agent.center_name IS '运营商名称';
COMMENT ON COLUMN operate_agent.site_id IS '站点ID';
COMMENT ON COLUMN operate_agent.site_name IS '站点名称';
COMMENT ON COLUMN operate_agent.master_id IS '站长ID';
COMMENT ON COLUMN operate_agent.master_name IS '站长名称';
COMMENT ON COLUMN operate_agent.topagent_id IS '总代ID';
COMMENT ON COLUMN operate_agent.topagent_name IS '总代账号';
COMMENT ON COLUMN operate_agent.agent_id IS '代理ID';
COMMENT ON COLUMN operate_agent.agent_name IS '代理账号';
COMMENT ON COLUMN operate_agent.player_num IS '玩家数量';
COMMENT ON COLUMN operate_agent.api_id IS 'api外键';
COMMENT ON COLUMN operate_agent.game_type_parent IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN operate_agent.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN operate_agent.static_time IS '统计时间';
COMMENT ON COLUMN operate_agent.create_time IS '创建时间';
COMMENT ON COLUMN operate_agent.transaction_order IS '交易单量';
COMMENT ON COLUMN operate_agent.transaction_volume IS '交易量';
COMMENT ON COLUMN operate_agent.effective_transaction IS '有效交易量';
COMMENT ON COLUMN operate_agent.profit_loss IS '交易盈亏';

-- 玩家经营报表 --
CREATE TABLE IF NOT EXISTS operate_player (
  id 					serial4 NOT NULL,
  center_id 			int4 NOT NULL,
  center_name 		varchar(100),
  site_id 			int4,
  site_name 			varchar(100),
  master_id 			int4,
  master_name 		varchar(100),
  topagent_id 		int4,
  topagent_name 		varchar(32),
  agent_id 			int4,
  agent_name 			varchar(32),
  player_id 			int4,
  player_name 		varchar(32),
  api_id 				int4,
  game_type_parent 	varchar(32),
  game_type 			varchar(32),
  static_time 		timestamp(6),
  create_time 		timestamp(6),
  transaction_order 		numeric(20,2) DEFAULT 0,
  transaction_volume 		numeric(20,2) DEFAULT 0,
  effective_transaction 	numeric(20,2) DEFAULT 0,
  profit_loss 			numeric(20,2) DEFAULT 0,
  CONSTRAINT operate_player_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);

ALTER TABLE operate_player OWNER TO postgres;
COMMENT ON TABLE operate_player IS '玩家经营报表 - Fly';
COMMENT ON COLUMN operate_player.center_id IS '运营商ID';
COMMENT ON COLUMN operate_player.center_name IS '运营商名称';
COMMENT ON COLUMN operate_player.site_id IS '站点ID';
COMMENT ON COLUMN operate_player.site_name IS '站点名称';
COMMENT ON COLUMN operate_player.master_id IS '站长ID';
COMMENT ON COLUMN operate_player.master_name IS '站长名称';
COMMENT ON COLUMN operate_player.topagent_id IS '总代ID';
COMMENT ON COLUMN operate_player.topagent_name IS '总代账号';
COMMENT ON COLUMN operate_player.agent_id IS '代理ID';
COMMENT ON COLUMN operate_player.agent_name IS '代理账号';
COMMENT ON COLUMN operate_player.player_id IS '玩家ID';
COMMENT ON COLUMN operate_player.player_name IS '玩家账号';
COMMENT ON COLUMN operate_player.api_id IS 'api外键';
COMMENT ON COLUMN operate_player.game_type_parent IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN operate_player.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN operate_player.static_time IS '统计时间';
COMMENT ON COLUMN operate_player.create_time IS '创建时间';
COMMENT ON COLUMN operate_player.transaction_order IS '交易单量';
COMMENT ON COLUMN operate_player.transaction_volume IS '交易量';
COMMENT ON COLUMN operate_player.effective_transaction IS '有效交易量';
COMMENT ON COLUMN operate_player.profit_loss IS '交易盈亏';

--修改菜单
UPDATE sys_resource SET url = 'report/ratio/ratioIndex.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '占成统计' AND parent_id = 23 AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET url = 'report/operate/operateIndex.html', remark = '统计报表-经营报表' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '经营报表' AND parent_id = 5 AND subsys_code = 'mcenter');

--修改sys_user_protection表字段error_times默认值 byEagle
ALTER TABLE "sys_user_protection" ALTER COLUMN "error_times" SET DEFAULT 0;