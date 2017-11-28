-- auto gen by Lins 2015-11-04 02:32:05
/*
	创建站点信息临时表.
	此表收集了当前站点，站长，运营商等信息。
	author:Lins
	date:2015.10.27
*/
select redo_sqls($$
create table IF NOT EXISTS sys_site_info(
		--站点ID
		siteid int4,
		--站点名称
		sitename VARCHAR,
		--站长ID
		masterid int4,
		--站长名称
		mastername VARCHAR,
		--用户类型
		usertype VARCHAR,
		subsyscode VARCHAR,
		--运营商ID
		operationid int4,
		--运营商名称
		operationname VARCHAR,
		operationusertype VARCHAR,
		operationsubsyscode VARCHAR
);

ALTER TABLE sys_site_info
  ADD CONSTRAINT pk_site PRIMARY KEY(siteid);

  COMMENT ON TABLE sys_site_info
  IS '站点相关资讯.Lins';
COMMENT ON COLUMN sys_site_info.siteid IS '站点ID';
COMMENT ON COLUMN sys_site_info.sitename IS '站点名称';
COMMENT ON COLUMN sys_site_info.masterid IS '站长ID';
COMMENT ON COLUMN sys_site_info.mastername IS '站长名称';
COMMENT ON COLUMN sys_site_info.usertype IS '用户类型：0运维，1运营，11运营子账号，2站长，21站长子账号，22总代，221总代子账号，23代理，231代理子账号，24玩家';
COMMENT ON COLUMN sys_site_info.subsyscode IS '子系统编号 mcenter 站长子账号 mcenterTopAgent 总代 mcenterAgent 代理 pcenter玩家';
COMMENT ON COLUMN sys_site_info.operationid IS '运营商ID';
COMMENT ON COLUMN sys_site_info.operationname IS '运营商名称';
COMMENT ON COLUMN sys_site_info.operationusertype IS '用户类型：0运维，1运营，11运营子账号，2站长，21站长子账号，22总代，221总代子账号，23代理，231代理子账号，24玩家';
COMMENT ON COLUMN sys_site_info.operationsubsyscode IS '子系统编号 mcenter 站长子账号 mcenterTopAgent 总代 mcenterAgent 代理 pcenter玩家';

  $$);