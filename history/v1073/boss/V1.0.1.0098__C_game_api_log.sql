-- auto gen by Alvin 2016-08-10 13:43:01
-- Table: game_api_log

DROP TABLE IF EXISTS game_api_log;

CREATE TABLE game_api_log
(
  id serial NOT NULL, -- 自增长ID
  api_account character(16), -- 玩家API帐号
  user_name character(16) NOT NULL, -- 平台玩家帐号
  user_id integer, -- 平台玩家ID
  site_id integer, -- 站点ID
  api_id integer, -- API.ID
  api_name character(10), -- API名称
  transaction_no character(32), -- 交易ID
  api_transaction_id character(32), -- API独立交易ID,
  type character(10), -- 请求类型
  amount numeric(20,2), --金额
  request_time timestamp without time zone,
  response_time timestamp without time zone, -- 回复时间
  expense bigint, -- 耗时.毫秒
  status_code int,--状态码
  status_desc character(100),--状态描述
  api_status_code character(30), -- API状态码
  api_status_desc character(100),--API状态描述
  context character(200),--上下文
  result text, -- 处理结果
  logFlow text, -- 日志流
  CONSTRAINT game_api_log_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE game_api_log
  OWNER TO postgres;
COMMENT ON TABLE game_api_log
  IS '记录API请求的日志';
COMMENT ON COLUMN game_api_log.id IS '自增长ID';
COMMENT ON COLUMN game_api_log.api_id IS 'API.ID';
COMMENT ON COLUMN game_api_log.api_name IS 'API名称';
COMMENT ON COLUMN game_api_log.transaction_no IS '交易ID';
COMMENT ON COLUMN game_api_log.api_transaction_id IS 'API独立交易ID, ';
COMMENT ON COLUMN game_api_log.type IS '请求类型';
COMMENT ON COLUMN game_api_log.amount IS '金额';
COMMENT ON COLUMN game_api_log.api_account IS '玩家API帐号';
COMMENT ON COLUMN game_api_log.user_name IS '平台玩家帐号';
COMMENT ON COLUMN game_api_log.user_id IS '平台玩家ID';
COMMENT ON COLUMN game_api_log.site_id IS '站点ID';
COMMENT ON COLUMN game_api_log.response_time IS '回复时间';
COMMENT ON COLUMN game_api_log.expense IS '耗时.毫秒';
COMMENT ON COLUMN game_api_log.status_code IS '--状态码';
COMMENT ON COLUMN game_api_log.status_desc IS '--状态描述';
COMMENT ON COLUMN game_api_log.api_status_code IS 'API状态码';
COMMENT ON COLUMN game_api_log.api_status_desc IS '--API状态描述';
COMMENT ON COLUMN game_api_log.context IS '上下文';
COMMENT ON COLUMN game_api_log.result IS '处理结果';
COMMENT ON COLUMN game_api_log.logFlow IS '日志流';

