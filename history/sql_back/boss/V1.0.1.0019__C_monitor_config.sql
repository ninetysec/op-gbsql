-- auto gen by longer 2015-11-19 13:47:02

--整理jason提交来的SQL脚本
CREATE TABLE IF NOT EXISTS monitor_config
(
  id SERIAL8 NOT NULL, -- 主键
  type_name character varying(256) NOT NULL, -- 接口服务名
  method_name character varying(100) NOT NULL, -- 方法名
  vo_name character varying(256) NOT NULL, -- 参数名（完整类路劲）
  priority smallint NOT NULL, -- 优先级
  create_time timestamp without time zone, -- 创建时间
  CONSTRAINT monitor_config_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE monitor_config
OWNER TO postgres;
COMMENT ON TABLE monitor_config
IS '监控配置--jasonli';
COMMENT ON COLUMN monitor_config.id IS '主键';
COMMENT ON COLUMN monitor_config.type_name IS '接口服务名';
COMMENT ON COLUMN monitor_config.method_name IS '方法名';
COMMENT ON COLUMN monitor_config.vo_name IS '参数名（完整类路劲）';
COMMENT ON COLUMN monitor_config.priority IS '优先级';
COMMENT ON COLUMN monitor_config.create_time IS '创建时间';

-- Table: monitor_config_para

-- DROP TABLE monitor_config_para;

CREATE TABLE IF NOT EXISTS monitor_config_para
(
  id bigint NOT NULL, -- 主键
  config_id integer NOT NULL, -- 外键，配置id
  para_name character varying(50) NOT NULL, -- 参数名字
  create_time timestamp without time zone,
  CONSTRAINT monitor_config_para_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE monitor_config_para
OWNER TO postgres;
COMMENT ON TABLE monitor_config_para
IS '监控配置具体参数--jasonli';
COMMENT ON COLUMN monitor_config_para.id IS '主键';
COMMENT ON COLUMN monitor_config_para.config_id IS '外键，配置id';
COMMENT ON COLUMN monitor_config_para.para_name IS '参数名字';
