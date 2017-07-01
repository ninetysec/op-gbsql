-- auto gen by tony 2017-06-29 15:15:22
select redo_sqls($$
  ALTER TABLE sys_datasource  ADD COLUMN idc character varying(1);
$$);
select redo_sqls($$
  ALTER TABLE sys_datasource  ADD COLUMN remote_url character varying(128);
$$);

COMMENT ON COLUMN "sys_datasource"."idc" IS '机房标志';
COMMENT ON COLUMN "sys_datasource"."remote_url" IS ' 远程数据源链接URL';


DROP VIEW if EXISTS v_sys_site_manage;

CREATE OR REPLACE VIEW v_sys_site_manage AS 
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
    (ds.ip || ':'||ds.port ||'|' || ds.dbname || '|' || ds.username) AS db,
    (replace(replace(ds.report_url, '/gb-sites?characterEncoding=UTF-8', ''), 'jdbc:postgresql://', '') || '|' || ds.dbname || '|' || ds.username) AS backupdb,
    ss.main_language AS locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE m.site_id = ss.id AND m.subsys_code::text = 'msites'::text AND m.page_url::text = '/'::text
         LIMIT 1) AS domain,
    ss.remark,
    ss.belong_to_idc,
    ds.idc AS idc
   FROM sys_user u
     LEFT JOIN sys_site ss ON u.id = ss.sys_user_id
     INNER JOIN sys_datasource ds ON ss.id = ds.id
     LEFT JOIN site_i18n i18n_center ON u.site_id = i18n_center.site_id AND i18n_center.type::text = 'site_name'::text AND i18n_center.locale = u.default_locale::bpchar
     LEFT JOIN site_i18n i18n_site ON ss.id = i18n_site.site_id AND i18n_site.type::text = 'site_name'::text AND i18n_site.locale = ss.main_language::bpchar
  WHERE u.user_type::text = '2'::text;

COMMENT ON VIEW v_sys_site_manage
  IS '站点管理 --tom';