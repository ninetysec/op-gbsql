-- auto gen by tony 2017-06-15 14:52:47

select redo_sqls($$
    ALTER TABLE sys_domain ADD COLUMN ssl_enabled boolean DEFAULT false;
    COMMENT ON COLUMN sys_domain.ssl_enabled IS 'SSL启用标示';
  $$);

DROP VIEW if EXISTS v_sys_site_domain;

CREATE OR REPLACE VIEW v_sys_site_domain AS
 SELECT dom.id,
    site.id AS site_id,
    site.name,
    site.timezone AS time_zone,
    site.main_language AS site_locale,
    site.code AS site_code,
    dom.id AS domain_id,
    dom.sys_user_id AS site_user_id,
    dom.domain,
    dom.is_default,
    dom.is_enable,
    dom.is_deleted,
    dom.sort,
    dom.subsys_code,
    dom.is_temp,
    dom.agent_id,
    dom.resolve_status,
    dom.create_time,
    site.logo_path,
    site.parent_id AS site_parent_id,
    site.status AS site_status,
    site.maintain_start_time,
    site.maintain_end_time,
    site.maintain_reason,
    site.template_code,
    site.theme,
    dom.page_url,
    dom.ssl_enabled
   FROM sys_site site,
    sys_domain dom,
    sys_user usr
  WHERE dom.sys_user_id = usr.id AND usr.id = site.sys_user_id AND site.id = dom.site_id;

