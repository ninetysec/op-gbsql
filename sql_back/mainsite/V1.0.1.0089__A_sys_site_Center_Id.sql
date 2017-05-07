-- auto gen by longer 2015-11-19 16:13:34

SELECT redo_sqls($$
  alter table sys_site add COLUMN parent_id INTEGER;
$$);
COMMENT ON COLUMN sys_site.parent_id is '站点父站';

update sys_site set parent_id = -1 where  sso_theme = 'ccenter';
update sys_site set parent_id = 0 where  sso_theme = 'mcenter';

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
                                                     dom.resolve_status,
                                                     site.logo_path,
                                                     site.parent_id as site_parent_id
                                                   FROM sys_site site,
                                                     sys_domain dom,
                                                     sys_user usr
                                                   WHERE (((dom.sys_user_id = usr.id) AND (usr.id = site.sys_user_id)) AND (site.id = dom.site_id));


CREATE OR REPLACE VIEW v_sys_site_user AS SELECT site.id,
                                                   site.name AS site_name,
                                                   usr.id AS sys_user_id,
                                                   usr.username,
                                                   usr.subsys_code,
                                                   usr.site_id AS center_id,
                                                   ext.name AS user_extend_name,
                                                   site.parent_id as site_parent_id
                                                 FROM sys_site site,
                                                   (sys_user usr
                                                     LEFT JOIN user_extend ext ON ((usr.id = ext.id)))
                                                 WHERE (site.sys_user_id = usr.id);