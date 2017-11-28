-- auto gen by tony 2017-07-01 15:23:57
DROP VIEW IF EXISTS v_site_master ;
DROP VIEW IF EXISTS v_sys_site_manage;
DROP VIEW IF EXISTS v_sys_site_user;
ALTER TABLE sys_site DROP COLUMN IF EXISTS belong_to_idc;

CREATE OR REPLACE VIEW "v_sys_site_manage" AS
 SELECT ss.id,
    ss.sys_user_id,
    u.username,
    ss.theme,
    ss.sso_theme,
    ss.status,
    ss.is_buildin,
    ss.postfix,
    ss.short_name,
    i18n_center.value AS parent_name,
    i18n_site.value AS site_name,
    ss.main_currency,
    ss.main_language,
    ss.web_site,
    ss.opening_time,
    ss.timezone,
    ss.traffic_statistics,
    ss.code,
    ss.logo_path,
    ss.site_classify_key,
    ss.site_net_scheme_id,
    ss.max_profit,
    u.owner_id,
    u.site_id AS center_id,
    ss.deposit,
    ss.template_code,
    ss.import_players_time,
    ss.maintain_start_time,
    ss.maintain_end_time,
    (((((((ds.ip)::text || ':'::text) || ds.port) || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS db,
    ((((replace(replace((ds.report_url)::text, '/gb-sites?characterEncoding=UTF-8'::text, ''::text), 'jdbc:postgresql://'::text, ''::text) || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS backupdb,
    ss.main_language AS locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE ((m.site_id = ss.id) AND ((m.subsys_code)::text = 'msites'::text) AND ((m.page_url)::text = '/'::text))
         LIMIT 1) AS domain,
    ss.remark,
    ds.idc
   FROM ((((sys_user u
     LEFT JOIN sys_site ss ON ((u.id = ss.sys_user_id)))
     JOIN sys_datasource ds ON ((ss.id = ds.id)))
     LEFT JOIN site_i18n i18n_center ON (((u.site_id = i18n_center.site_id) AND ((i18n_center.type)::text = 'site_name'::text) AND (i18n_center.locale = (u.default_locale)::bpchar))))
     LEFT JOIN site_i18n i18n_site ON (((ss.id = i18n_site.site_id) AND ((i18n_site.type)::text = 'site_name'::text) AND (i18n_site.locale = (ss.main_language)::bpchar))))
  WHERE ((u.user_type)::text = '2'::text);

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';

CREATE OR REPLACE VIEW "v_sys_site_user" AS
 SELECT site.id,
    site.name AS site_name,
    usr.id AS sys_user_id,
    site.status,
    usr.username,
    usr.subsys_code,
    usr.site_id AS center_id,
    site.parent_id AS site_parent_id,
    site.main_language AS site_locale,
    site.timezone
   FROM sys_site site,
    sys_user usr
  WHERE (site.sys_user_id = usr.id);