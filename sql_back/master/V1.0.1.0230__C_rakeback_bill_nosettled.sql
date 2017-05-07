-- auto gen by cheery 2015-11-25 10:16:32
--创建返水未出账单表
CREATE TABLE IF NOT EXISTS rakeback_bill_nosettled(
  id SERIAL4 NOT NULL,
  start_time TIMESTAMP(6),
  end_time TIMESTAMP(6),
  rakeback_total numeric(20,2),
  statistics_time TIMESTAMP(6),
  CONSTRAINT "rakeback_bill_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "rakeback_bill_nosettled" OWNER TO "postgres";

COMMENT ON TABLE rakeback_bill_nosettled IS '返水未出账单表--susu';
COMMENT ON COLUMN rakeback_bill_nosettled.id IS '主键';
COMMENT ON COLUMN rakeback_bill_nosettled.start_time IS '预结算起始时间';
COMMENT ON COLUMN rakeback_bill_nosettled.end_time IS '预结算结束时间';
COMMENT ON COLUMN rakeback_bill_nosettled.rakeback_total IS '应付返水';
COMMENT ON COLUMN rakeback_bill_nosettled.statistics_time IS '统计时间';


--创建api返水未出账单表
CREATE TABLE IF NOT EXISTS rakeback_api_nosettled(
  id SERIAL4 NOT NULL,
  rakeback_bill_nosettled_id INT4,
  player_id INT4,
  api_id INT4,
  api_type_id INT4,
  game_type varchar(20),
  rakeback_total NUMERIC(20,2),
  CONSTRAINT "rakeback_api_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE rakeback_api_nosettled OWNER TO "postgres";

COMMENT ON TABLE rakeback_api_nosettled IS 'api返水未出账单表--susu';

COMMENT ON COLUMN rakeback_api_nosettled.id IS '主键';

COMMENT ON COLUMN rakeback_api_nosettled.rakeback_bill_nosettled_id IS '未出账单ID';

COMMENT ON COLUMN rakeback_api_nosettled.player_id IS '玩家ID';

COMMENT ON COLUMN rakeback_api_nosettled.api_id IS 'API';

COMMENT ON COLUMN rakeback_api_nosettled.api_type_id IS 'api分类';

COMMENT ON COLUMN rakeback_api_nosettled.game_type IS '游戏分类,即api二级分类';

COMMENT ON COLUMN rakeback_api_nosettled.rakeback_total IS '返水';


--创建玩家返水未出账单表
CREATE TABLE IF NOT EXISTS rakeback_player_nosettled(
  id SERIAL4 NOT NULL,
  rakeback_bill_nosettled_id INT4,
  top_agent_id INT4,
  agent_id INT4,
  player_id INT4,
  username VARCHAR(100),
  rank_id INT4,
  rank_name varchar(50),
  risk_marker BOOL,
  rakeback_total NUMERIC(20,2),
  CONSTRAINT "rakeback_player_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE rakeback_player_nosettled OWNER TO "postgres";

COMMENT ON TABLE rakeback_player_nosettled IS '玩家返水未出账单表--susu';

COMMENT ON COLUMN rakeback_player_nosettled.id IS '主键';

COMMENT ON COLUMN rakeback_player_nosettled.rakeback_bill_nosettled_id IS '未出账单ID';

COMMENT ON COLUMN rakeback_player_nosettled.top_agent_id IS '总代ID';

COMMENT ON COLUMN rakeback_player_nosettled.agent_id IS '代理ID';

COMMENT ON COLUMN rakeback_player_nosettled.player_id IS '玩家ID';

COMMENT ON COLUMN rakeback_player_nosettled.username IS '玩家账号';

COMMENT ON COLUMN rakeback_player_nosettled.rank_id IS '层级ID';

COMMENT ON COLUMN rakeback_player_nosettled.rank_name IS '层级名称';

COMMENT ON COLUMN rakeback_player_nosettled.risk_marker IS '层级危险标示';

COMMENT ON COLUMN rakeback_player_nosettled.rakeback_total IS '应付返水';