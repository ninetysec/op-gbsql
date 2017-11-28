-- auto gen by Lins 2016-01-11 06:05:58
--修改Game API相关表字段的长度.

CREATE TABLE IF NOT EXISTS game_api_interface (
  id SERIAL4 PRIMARY KEY , -- 主键
  protocol CHARACTER VARYING(8) NOT NULL, -- 协议
  api_action CHARACTER VARYING(200), -- 请求的action
  local_action CHARACTER VARYING(32) NOT NULL, -- 本地j自定义的action(面向业务系统)
  http_method CHARACTER VARYING, -- http提交方式
  remarks CHARACTER VARYING, -- 64
  param_class CHARACTER VARYING NOT NULL, -- 请求参数对象的类
  result_class CHARACTER VARYING(64) NOT NULL, -- 返回的结果类
  request_content_type CHARACTER VARYING(32), -- 请求的内容类型
  response_content_type CHARACTER VARYING(32) NOT NULL, -- 响应的内容类型
  provider_id INTEGER NOT NULL, -- api提供商id
  ext_json CHARACTER VARYING(500) -- json格式的扩展信息
);
CREATE INDEX fk_game_api_interface_provider_id ON game_api_interface USING BTREE (provider_id);
COMMENT ON TABLE game_api_interface IS '游戏api接口信息 -- Kevice';
COMMENT ON COLUMN game_api_interface.id IS '主键';
COMMENT ON COLUMN game_api_interface.protocol IS '协议';
COMMENT ON COLUMN game_api_interface.api_action IS '请求的action';
COMMENT ON COLUMN game_api_interface.local_action IS '本地j自定义的action(面向业务系统)';
COMMENT ON COLUMN game_api_interface.http_method IS 'http提交方式';
COMMENT ON COLUMN game_api_interface.remarks IS '64';
COMMENT ON COLUMN game_api_interface.param_class IS '请求参数对象的类';
COMMENT ON COLUMN game_api_interface.result_class IS '返回的结果类';
COMMENT ON COLUMN game_api_interface.request_content_type IS '请求的内容类型';
COMMENT ON COLUMN game_api_interface.response_content_type IS '响应的内容类型';
COMMENT ON COLUMN game_api_interface.provider_id IS 'api提供商id';
COMMENT ON COLUMN game_api_interface.ext_json IS 'json格式的扩展信息';


CREATE TABLE if NOT EXISTS game_api_provider (
  id SERIAL4 PRIMARY KEY , -- 主键
  abbr_name CHARACTER VARYING(16) NOT NULL, -- 简称
  full_name CHARACTER VARYING(64), -- 全称
  api_url CHARACTER VARYING(128) NOT NULL, -- api调用的url
  remarks CHARACTER VARYING(128), -- 备注
  jar_url CHARACTER VARYING(128), -- 具体实现jar包的url
  api_class CHARACTER VARYING(128), -- api具体实现的类(全类名)
  jar_version CHARACTER VARYING(16), -- jar包版本
  ext_json CHARACTER VARYING(500) -- json格式的扩展信息
);
COMMENT ON TABLE game_api_provider IS '游戏api提供商 -- Kevice';
COMMENT ON COLUMN game_api_provider.id IS '主键';
COMMENT ON COLUMN game_api_provider.abbr_name IS '简称';
COMMENT ON COLUMN game_api_provider.full_name IS '全称';
COMMENT ON COLUMN game_api_provider.api_url IS 'api调用的url';
COMMENT ON COLUMN game_api_provider.remarks IS '备注';
COMMENT ON COLUMN game_api_provider.jar_url IS '具体实现jar包的url';
COMMENT ON COLUMN game_api_provider.api_class IS 'api具体实现的类(全类名)';
COMMENT ON COLUMN game_api_provider.jar_version IS 'jar包版本';
COMMENT ON COLUMN game_api_provider.ext_json IS 'json格式的扩展信息';

select redo_sqls($$
alter table game_api_interface ALTER column ext_json TYPE varchar(500);
alter table game_api_provider ALTER column ext_json TYPE varchar(500);
$$);