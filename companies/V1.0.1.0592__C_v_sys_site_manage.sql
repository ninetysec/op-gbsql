-- auto gen by linsen 2018-04-03 21:56:28
-- 修改站点管理视图-买分参数 by linsen
DROP VIEW IF EXISTS v_sys_site_manage;
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
    ssc.max_profit,
    u.owner_id,
    u.site_id AS center_id,
    ss.deposit,
    ss.template_code,
    ss.import_players_time,
    ss.maintain_start_time,
    ss.maintain_end_time,
	 ssc.current_transfer_limit,
    (((((((ds.ip)::text || ':'::text) || ds.port) || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS db,
    ((((replace(replace((ds.report_url)::text, '/gb-sites?characterEncoding=UTF-8'::text, ''::text), 'jdbc:postgresql://'::text, ''::text) || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS backupdb,
    ss.main_language AS locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE ((m.site_id = ss.id) AND ((m.subsys_code)::text = 'msites'::text) AND ((m.page_url)::text = '/'::text))
         LIMIT 1) AS domain,
    ss.remark,
    ds.idc,
        CASE
            WHEN ((ssc.max_profit + COALESCE(ssc.credit_line)) = (0)::numeric) THEN (0)::numeric
            ELSE ((COALESCE(ssc.has_use_profit) * (100)::numeric) / (ssc.max_profit + COALESCE(ssc.credit_line)))
        END AS profit_percent
   FROM (((((sys_user u
     LEFT JOIN sys_site ss ON ((u.id = ss.sys_user_id)))
     LEFT JOIN sys_site_credit ssc ON ((ss.id = ssc.id)))
     JOIN sys_datasource ds ON ((ss.id = ds.id)))
     LEFT JOIN site_i18n i18n_center ON (((u.site_id = i18n_center.site_id) AND ((i18n_center.type)::text = 'site_name'::text) AND (i18n_center.locale = (u.default_locale)::bpchar))))
     LEFT JOIN site_i18n i18n_site ON (((ss.id = i18n_site.site_id) AND ((i18n_site.type)::text = 'site_name'::text) AND (i18n_site.locale = (ss.main_language)::bpchar))))
  WHERE ((u.user_type)::text = '2'::text);


COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';