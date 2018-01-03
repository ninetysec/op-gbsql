-- auto gen by longer 2016-01-15 11:39:09

CREATE TABLE sys_site_visitor (
  id SERIAL8 PRIMARY KEY , -- 主键
  site_id INTEGER, -- 站点ID
  sys_user_id INTEGER, -- 用户ID
  visitor CHARACTER VARYING(32), -- 访客标识码
  ip BIGINT, -- IP
  start_time TIMESTAMP WITHOUT TIME ZONE, -- 访问时间
  source CHARACTER VARYING(512), -- 来源
  access_page CHARACTER VARYING(256), -- 入口页面
  times INTEGER, -- 访问时长(单位秒)
  pages INTEGER -- 访问页数
);
CREATE INDEX fk_sys_site_visitor_sys_user_id ON sys_site_visitor USING BTREE (sys_user_id);
CREATE INDEX fk_sys_site_visitor_site_id ON sys_site_visitor USING BTREE (site_id);
COMMENT ON TABLE sys_site_visitor IS '系统站点访客表--Longer';
COMMENT ON COLUMN sys_site_visitor.id IS '主键';
COMMENT ON COLUMN sys_site_visitor.site_id IS '站点ID';
COMMENT ON COLUMN sys_site_visitor.sys_user_id IS '用户ID';
COMMENT ON COLUMN sys_site_visitor.visitor IS '访客标识码';
COMMENT ON COLUMN sys_site_visitor.ip IS 'IP';
COMMENT ON COLUMN sys_site_visitor.start_time IS '访问时间';
COMMENT ON COLUMN sys_site_visitor.source IS '来源';
COMMENT ON COLUMN sys_site_visitor.access_page IS '入口页面';
COMMENT ON COLUMN sys_site_visitor.times IS '访问时长(单位秒)';
COMMENT ON COLUMN sys_site_visitor.pages IS '访问页数';