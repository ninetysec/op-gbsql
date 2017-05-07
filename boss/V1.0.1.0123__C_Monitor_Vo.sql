-- auto gen by tony 2016-09-11 14:23:49
CREATE TABLE IF NOT EXISTS monitor_vo
(
  id serial NOT NULL, -- 监控对象主键
  is_sync integer, -- 是否同步
  rule_instance character varying(256), -- 规则实例
  delay_sec integer, -- 延迟秒数
  status integer, -- 处理状态
  priority integer, -- 优先级
  dubbo_version character varying(256), -- dubbo_version
  config_id bigint, -- 监控配置ID
  err_message character varying(2560), -- 错误信息细
  vo_content text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE monitor_vo
  OWNER TO "gb-boss";
COMMENT ON TABLE monitor_vo
  IS '监控数据表';
COMMENT ON COLUMN monitor_vo.id IS '监控对象主键';
COMMENT ON COLUMN monitor_vo.is_sync IS '是否同步';
COMMENT ON COLUMN monitor_vo.rule_instance IS '规则实例';
COMMENT ON COLUMN monitor_vo.delay_sec IS '延迟秒数';
COMMENT ON COLUMN monitor_vo.status IS '处理状态';
COMMENT ON COLUMN monitor_vo.priority IS '优先级';
COMMENT ON COLUMN monitor_vo.dubbo_version IS 'dubbo_version';
COMMENT ON COLUMN monitor_vo.config_id IS '监控配置ID';
COMMENT ON COLUMN monitor_vo.err_message IS '错误信息细';