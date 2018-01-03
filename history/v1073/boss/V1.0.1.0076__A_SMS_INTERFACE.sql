-- auto gen by lenovo 2016-06-28 03:30:52
-- Table: sms_interface

DROP TABLE IF EXISTS sms_interface;

CREATE TABLE sms_interface
(
  id serial NOT NULL, -- 主键
  abbr_name character varying(16), -- 简称
  full_name character varying(64), -- 全称
  username character varying(20), -- 接口用户名
  password character varying(20), -- 接口密码
  data_key character varying(64), -- 接口密钥
  request_url character varying(128) NOT NULL, -- 请求接口地址
  multiple_split character varying(20), -- 多个接受用户分隔符
  remarks character varying(128), -- 备注
  api_class character varying(128), -- api具体实现的类(全类名)
  interface_version character varying(16), -- 版本
  ext_json character varying(1500), -- json格式的扩展信息
  multiple_num integer, -- 多个接受用户最大数量
  request_content_type character varying(20), -- 请求类型
  response_content_type character varying(20), -- 响应类型
  reques_method character varying(20), -- 请求方法
  CONSTRAINT pk_sms_interface PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sms_interface
  OWNER TO postgres;
COMMENT ON TABLE sms_interface
  IS '短信接口';
COMMENT ON COLUMN sms_interface.id IS '主键';
COMMENT ON COLUMN sms_interface.abbr_name IS '简称';
COMMENT ON COLUMN sms_interface.full_name IS '全称';
COMMENT ON COLUMN sms_interface.username IS '接口用户名';
COMMENT ON COLUMN sms_interface.password IS '接口密码';
COMMENT ON COLUMN sms_interface.data_key IS '接口密钥';
COMMENT ON COLUMN sms_interface.request_url IS '请求接口地址';
COMMENT ON COLUMN sms_interface.multiple_split IS '多个接受用户分隔符';
COMMENT ON COLUMN sms_interface.remarks IS '备注';
COMMENT ON COLUMN sms_interface.api_class IS 'api具体实现的类(全类名)';
COMMENT ON COLUMN sms_interface.interface_version IS '版本';
COMMENT ON COLUMN sms_interface.ext_json IS 'json格式的扩展信息';
COMMENT ON COLUMN sms_interface.multiple_num IS '多个接受用户最大数量';
COMMENT ON COLUMN sms_interface.request_content_type IS '请求类型';
COMMENT ON COLUMN sms_interface.response_content_type IS '响应类型';
COMMENT ON COLUMN sms_interface.reques_method IS '请求方法';

