-- auto gen by longer 2015-09-10 20:32:34
--系统日志表-用户类型

CREATE TABLE IF NOT EXISTS sys_audit_log (
  id CHARACTER VARYING(32) PRIMARY KEY NOT NULL, -- 主键
  entity_id BIGINT, -- 业务实体id(被操作对象id)
  operator_id INTEGER, -- 操作员id
  operator CHARACTER VARYING(50), -- 操作员
  operate_time TIMESTAMP(6) WITHOUT TIME ZONE, -- 操作时间
  operate_type_id INTEGER, -- 操作类型(ID)
  operate_type CHARACTER VARYING(50), -- 操作类型
  operate_url CHARACTER VARYING(2048), -- 操作URL(完整路径)
  module_name CHARACTER VARYING(255), -- 模块名(多层级)
  module_obj CHARACTER VARYING(255), -- 模块对象(当前层级操作模块的对象)
  module_type CHARACTER VARYING(3), -- 模型类型
  description CHARACTER VARYING(2048), -- 操作描述
  string_params CHARACTER VARYING(2048), -- 描述参数,对应:{0}
  object_params CHARACTER VARYING(2048), -- 描述参数,JSON串,对应:${}
  request_referer CHARACTER VARYING(2048), -- requestReferer
  request_type CHARACTER VARYING(10), -- 请求类型（GET|POST）
  request_form_data CHARACTER VARYING(2048), --  POST请求数据
  response_view_name CHARACTER VARYING(255), -- 返回视图
  response_status INTEGER, -- 返回状态码(200\\300\\404等)
  is_deleted BOOLEAN, -- 是否被删除
  operate_ip BIGINT, -- 操作(客户端)IP
  client_os CHARACTER VARYING(50), -- 客户端操作系统
  client_browser CHARACTER VARYING(50), -- 客户端浏览器
  user_type CHARACTER VARYING(5) -- 用户类型(参观:sys_user)
);
COMMENT ON TABLE sys_audit_log IS '系统审计日志表';
COMMENT ON COLUMN sys_audit_log.id IS '主键';
COMMENT ON COLUMN sys_audit_log.entity_id IS '业务实体id(被操作对象id)';
COMMENT ON COLUMN sys_audit_log.operator_id IS '操作员id';
COMMENT ON COLUMN sys_audit_log.operator IS '操作员';
COMMENT ON COLUMN sys_audit_log.operate_time IS '操作时间';
COMMENT ON COLUMN sys_audit_log.operate_type_id IS '操作类型(ID)';
COMMENT ON COLUMN sys_audit_log.operate_type IS '操作类型';
COMMENT ON COLUMN sys_audit_log.operate_url IS '操作URL(完整路径)';
COMMENT ON COLUMN sys_audit_log.module_name IS '模块名(多层级)';
COMMENT ON COLUMN sys_audit_log.module_obj IS '模块对象(当前层级操作模块的对象)';
COMMENT ON COLUMN sys_audit_log.module_type IS '模型类型';
COMMENT ON COLUMN sys_audit_log.description IS '操作描述';
COMMENT ON COLUMN sys_audit_log.string_params IS '描述参数,对应:{0}';
COMMENT ON COLUMN sys_audit_log.object_params IS '描述参数,JSON串,对应:${}';
COMMENT ON COLUMN sys_audit_log.request_referer IS 'requestReferer';
COMMENT ON COLUMN sys_audit_log.request_type IS '请求类型（GET|POST）';
COMMENT ON COLUMN sys_audit_log.request_form_data IS ' POST请求数据';
COMMENT ON COLUMN sys_audit_log.response_view_name IS '返回视图';
COMMENT ON COLUMN sys_audit_log.response_status IS '返回状态码(200\\300\\404等)';
COMMENT ON COLUMN sys_audit_log.is_deleted IS '是否被删除';
COMMENT ON COLUMN sys_audit_log.operate_ip IS '操作(客户端)IP';
COMMENT ON COLUMN sys_audit_log.client_os IS '客户端操作系统';
COMMENT ON COLUMN sys_audit_log.client_browser IS '客户端浏览器';
COMMENT ON COLUMN sys_audit_log.user_type IS '用户类型(参观:sys_user)';

select redo_sqls($$
  alter table sys_audit_log add COLUMN user_type CHARACTER VARYING(5);
$$);
COMMENT ON COLUMN sys_audit_log.user_type IS '用户类型(参观:sys_user)';