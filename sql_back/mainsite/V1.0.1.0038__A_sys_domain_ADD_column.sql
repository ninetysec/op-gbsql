-- auto gen by longer 2015-10-14 13:44:18

-- 域名添加代理用户ID,是否解析字段
select redo_sqls($$
  alter table sys_domain add COLUMN agent_id integer;
  alter table sys_domain add COLUMN is_resolve BOOL;
$$);

COMMENT ON COLUMN sys_domain.agent_id is '代理用户ID';
COMMENT ON COLUMN sys_domain.is_resolve is '是否解析';

CREATE OR REPLACE VIEW v_sys_site_domain AS SELECT dom.id,
   site.id AS site_id,
   site.name,
   site.timezone AS time_zone,
   site.main_language AS site_locale,
   site.code AS site_code,
   dom.id AS domain_id,
   dom.sys_user_id AS master_id,
   dom.domain,
   dom.is_default,
   dom.is_enable,
   dom.is_deleted,
   dom.sort,
   dom.subsys_code,
   usr.site_id AS center_id,
   dom.agent_id,
   dom.is_resolve
FROM sys_site site,
   sys_domain dom,
   sys_user usr
WHERE ((dom.sys_user_id = usr.id) AND (usr.id = site.sys_user_id));

--预先所有域名都当:解析过
update sys_domain set is_resolve = true;
