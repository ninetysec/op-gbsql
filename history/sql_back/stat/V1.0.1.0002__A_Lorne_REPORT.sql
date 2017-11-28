-- auto gen by loong
-- Table: operating_report_agent

-- DROP TABLE operating_report_agent;

CREATE TABLE IF NOT EXISTS operating_report_agent
(
  id serial4 NOT NULL,
  site_id integer, -- 站点ID
  top_agent_id integer, -- 总代ID
  top_agent_name character varying(32), -- 总代账号
  agent_id integer, -- 代理ID
  agent_name character varying(32), -- 代理账号
  players_num integer, -- 玩家数量
  api_id integer, -- api外键
  game_type_parent character varying(32), -- 一级游戏分类:Dicts:Module:common Dict_Type:gameType
  game_type character varying(32), -- 二级游戏类别:Dicts:Module:common Dict_Type:gameType
  statistical_date timestamp(6) without time zone, -- 统计日期
  create_time timestamp(6) without time zone, -- 创建时间
  transaction_order numeric(20,2) DEFAULT 0, -- 当天交易单量
  transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  effective_transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  transaction_profit_loss numeric(20,2) DEFAULT 0, -- 当天交易盈亏
  master_id integer, -- 站长ID
  CONSTRAINT operating_report_agent_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE operating_report_agent
  OWNER TO postgres;
COMMENT ON TABLE operating_report_agent
  IS '代理经营报表--lorne';
COMMENT ON COLUMN operating_report_agent.site_id IS '站点ID';
COMMENT ON COLUMN operating_report_agent.top_agent_id IS '总代ID';
COMMENT ON COLUMN operating_report_agent.top_agent_name IS '总代账号';
COMMENT ON COLUMN operating_report_agent.agent_id IS '代理ID';
COMMENT ON COLUMN operating_report_agent.agent_name IS '代理账号';
COMMENT ON COLUMN operating_report_agent.players_num IS '玩家数量';
COMMENT ON COLUMN operating_report_agent.api_id IS 'api外键';
COMMENT ON COLUMN operating_report_agent.game_type_parent IS '一级游戏分类:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_agent.game_type IS '二级游戏类别:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_agent.statistical_date IS '统计日期';
COMMENT ON COLUMN operating_report_agent.create_time IS '创建时间';
COMMENT ON COLUMN operating_report_agent.transaction_order IS '当天交易单量';
COMMENT ON COLUMN operating_report_agent.transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_agent.effective_transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_agent.transaction_profit_loss IS '当天交易盈亏';
COMMENT ON COLUMN operating_report_agent.master_id IS '站长ID';

-- Table: "operating_report_players "

-- DROP TABLE "operating_report_players ";

CREATE TABLE IF NOT EXISTS "operating_report_players "
(
  id serial4 NOT NULL,
  site_id integer, -- 站点ID
  top_agent_id integer, -- 总代ID
  top_agent_name character varying(32), -- 总代账号
  agent_id integer, -- 代理ID
  agent_name character varying(32), -- 代理账号
  user_id integer, -- 玩家ID
  user_name character varying(32), -- 玩家账号
  api_id integer, -- api外键
  game_type_parent character varying(32), -- 一级游戏分类:Dicts:Module:common Dict_Type:gameType
  game_type character varying(32), -- 二级游戏类别:Dicts:Module:common Dict_Type:gameType
  statistical_date timestamp without time zone, -- 统计日期
  create_time timestamp without time zone, -- 创建时间
  transaction_order numeric(20,2) DEFAULT 0, -- 当天交易单量
  transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  effective_transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  transaction_profit_loss numeric(20,2) DEFAULT 0, -- 当天交易盈亏
  master_id integer, -- 站长ID
  CONSTRAINT "operating _report_players _pkey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "operating_report_players "
  OWNER TO postgres;
COMMENT ON TABLE "operating_report_players "
  IS '玩家经营报表--lorne';
COMMENT ON COLUMN "operating_report_players ".site_id IS '站点ID';
COMMENT ON COLUMN "operating_report_players ".top_agent_id IS '总代ID';
COMMENT ON COLUMN "operating_report_players ".top_agent_name IS '总代账号';
COMMENT ON COLUMN "operating_report_players ".agent_id IS '代理ID';
COMMENT ON COLUMN "operating_report_players ".agent_name IS '代理账号';
COMMENT ON COLUMN "operating_report_players ".user_id IS '玩家ID';
COMMENT ON COLUMN "operating_report_players ".user_name IS '玩家账号';
COMMENT ON COLUMN "operating_report_players ".api_id IS 'api外键';
COMMENT ON COLUMN "operating_report_players ".game_type_parent IS '一级游戏分类:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN "operating_report_players ".game_type IS '二级游戏类别:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN "operating_report_players ".statistical_date IS '统计日期';
COMMENT ON COLUMN "operating_report_players ".create_time IS '创建时间';
COMMENT ON COLUMN "operating_report_players ".transaction_order IS '当天交易单量';
COMMENT ON COLUMN "operating_report_players ".transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN "operating_report_players ".effective_transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN "operating_report_players ".transaction_profit_loss IS '当天交易盈亏';
COMMENT ON COLUMN "operating_report_players ".master_id IS '站长ID';

-- Table: operating_report_site

-- DROP TABLE operating_report_site;

CREATE TABLE IF NOT EXISTS operating_report_site
(
  id serial4 NOT NULL,
  site_id integer, -- 站点ID
  players_num integer, -- 玩家数量
  api_id integer, -- api外键
  game_type_parent character varying(32), -- 一级游戏分类:Dicts:Module:common Dict_Type:gameType
  game_type character varying(32), -- 二级游戏类别:Dicts:Module:common Dict_Type:gameType
  statistical_date timestamp(6) without time zone, -- 统计日期
  create_time timestamp(6) without time zone, -- 创建时间
  transaction_order numeric(20,2) DEFAULT 0, -- 当天交易单量
  transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  effective_transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  transaction_profit_loss numeric(20,2) DEFAULT 0, -- 当天交易盈亏
  master_id integer, -- 站长ID
  CONSTRAINT operating_report_site_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE operating_report_site
  OWNER TO postgres;
COMMENT ON TABLE operating_report_site
  IS '站点经营报表--lorne';
COMMENT ON COLUMN operating_report_site.site_id IS '站点ID';
COMMENT ON COLUMN operating_report_site.players_num IS '玩家数量';
COMMENT ON COLUMN operating_report_site.api_id IS 'api外键';
COMMENT ON COLUMN operating_report_site.game_type_parent IS '一级游戏分类:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_site.game_type IS '二级游戏类别:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_site.statistical_date IS '统计日期';
COMMENT ON COLUMN operating_report_site.create_time IS '创建时间';
COMMENT ON COLUMN operating_report_site.transaction_order IS '当天交易单量';
COMMENT ON COLUMN operating_report_site.transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_site.effective_transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_site.transaction_profit_loss IS '当天交易盈亏';
COMMENT ON COLUMN operating_report_site.master_id IS '站长ID';

-- Table: operating_report_top_agent

-- DROP TABLE operating_report_top_agent;

CREATE TABLE IF NOT EXISTS operating_report_top_agent
(
  id serial4 NOT NULL,
  site_id integer, -- 站点ID
  top_agent_id integer, -- 总代ID
  top_agent_name character varying(32), -- 总代账号
  players_num integer, -- 玩家数量
  api_id integer, -- api外键
  game_type_parent character varying(32), -- 一级游戏分类:Dicts:Module:common Dict_Type:gameType
  game_type character varying(32), -- 二级游戏类别:Dicts:Module:common Dict_Type:gameType
  statistical_date timestamp(6) without time zone, -- 统计日期
  create_time timestamp(6) without time zone, -- 创建时间
  transaction_order numeric(20,2) DEFAULT 0, -- 当天交易单量
  transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  effective_transaction_volume numeric(20,2) DEFAULT 0, -- 当天有效交易量
  transaction_profit_loss numeric(20,2) DEFAULT 0, -- 当天交易盈亏
  master_id integer, -- 站长ID
  CONSTRAINT operating_report_top_agent_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE operating_report_top_agent
  OWNER TO postgres;
COMMENT ON TABLE operating_report_top_agent
  IS '总代经营报表--lorne';
COMMENT ON COLUMN operating_report_top_agent.site_id IS '站点ID';
COMMENT ON COLUMN operating_report_top_agent.top_agent_id IS '总代ID';
COMMENT ON COLUMN operating_report_top_agent.top_agent_name IS '总代账号';
COMMENT ON COLUMN operating_report_top_agent.players_num IS '玩家数量';
COMMENT ON COLUMN operating_report_top_agent.api_id IS 'api外键';
COMMENT ON COLUMN operating_report_top_agent.game_type_parent IS '一级游戏分类:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_top_agent.game_type IS '二级游戏类别:Dicts:Module:common Dict_Type:gameType';
COMMENT ON COLUMN operating_report_top_agent.statistical_date IS '统计日期';
COMMENT ON COLUMN operating_report_top_agent.create_time IS '创建时间';
COMMENT ON COLUMN operating_report_top_agent.transaction_order IS '当天交易单量';
COMMENT ON COLUMN operating_report_top_agent.transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_top_agent.effective_transaction_volume IS '当天有效交易量';
COMMENT ON COLUMN operating_report_top_agent.transaction_profit_loss IS '当天交易盈亏';
COMMENT ON COLUMN operating_report_top_agent.master_id IS '站长ID';

