-- auto gen by longer 2015-09-10 20:17:57
--系统站点访客表
create table IF NOT EXISTS sys_site_visitor(
  id SERIAL8 NOT NULL PRIMARY KEY ,
  site_id INTEGER,
  sys_user_id INTEGER,
  visitor CHARACTER VARYING(32),
  ip INT8,
  start_time TIMESTAMP WITHOUT TIME ZONE,
  source CHARACTER VARYING(512),
  access_page CHARACTER VARYING(256),
  times INTEGER,
  pages INTEGER
);


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