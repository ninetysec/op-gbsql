-- auto gen by admin 2016-10-02 16:05:15
-- Table: api_monitor_trans_conf

-- DROP TABLE api_monitor_trans_conf;
CREATE TABLE IF NOT EXISTS api_monitor_trans_conf
(
  id serial NOT NULL, -- 主键
  datasourceId int4, -- 数据源id
  userId int4, -- 用户id
  username character varying(20), -- 用户名称
  site_code character varying(20),
  amount numeric(20,2), -- 转账金额
  defaultValiNum int4, -- 默认验证次数
  seconds int4, -- 验证时间区间（秒）
  CONSTRAINT pk_api_monitor_trans_conf PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE api_monitor_trans_conf
  IS 'API转账异常监控';
COMMENT ON COLUMN api_monitor_trans_conf.id IS '主键';
COMMENT ON COLUMN api_monitor_trans_conf.datasourceId IS '数据源id';
COMMENT ON COLUMN api_monitor_trans_conf.userId IS '用户id';
COMMENT ON COLUMN api_monitor_trans_conf.username IS '用户名称';
COMMENT ON COLUMN api_monitor_trans_conf.amount IS '转账金额';
COMMENT ON COLUMN api_monitor_trans_conf.defaultValiNum IS '默认验证次数';
COMMENT ON COLUMN api_monitor_trans_conf.seconds IS '验证时间区间（秒）';

