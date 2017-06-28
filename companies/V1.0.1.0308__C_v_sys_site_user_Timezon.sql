-- auto gen by Water 2017-06-17 16:36:51

--alter view: add new column timezone
drop view IF EXISTS v_sys_site_user;
CREATE OR REPLACE VIEW v_sys_site_user AS SELECT site.id,
                                 site.name AS site_name,
                                 usr.id AS sys_user_id,
                                 site.status,
                                 usr.username,
                                 usr.subsys_code,
                                 usr.site_id AS center_id,
                                 site.parent_id AS site_parent_id,
                                 site.main_language AS site_locale,
                                 site.belong_to_idc,
                                 site.belong_to_idc as idc,
                                 site.timezone
                               FROM sys_site site,
                                 sys_user usr
                               WHERE (site.sys_user_id = usr.id);


CREATE or REPLACE VIEW v_sys_site_manage AS SELECT ss.id,
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
                                   (((((ds.ip)::text || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS db,
                                   ((((replace(replace((ds.report_url)::text, ':5432/gb-sites?characterEncoding=UTF-8'::text, ''::text), 'jdbc:postgresql://'::text, ''::text) || '|'::text) || (ds.dbname)::text) || '|'::text) || (ds.username)::text) AS backupdb,
                                   ss.main_language AS locale,
                                   ( SELECT m.domain
                                     FROM sys_domain m
                                     WHERE ((m.site_id = ss.id) AND ((m.subsys_code)::text = 'msites'::text) AND ((m.page_url)::text = '/'::text))
                                     LIMIT 1) AS domain,
                                   ss.remark,
                                   ss.belong_to_idc,
                                   ss.belong_to_idc as idc
                                 FROM ((((sys_user u
                                   LEFT JOIN sys_site ss ON ((u.id = ss.sys_user_id)))
                                   LEFT JOIN sys_datasource ds ON ((ss.id = ds.id)))
                                   LEFT JOIN site_i18n i18n_center ON (((u.site_id = i18n_center.site_id) AND ((i18n_center.type)::text = 'site_name'::text) AND (i18n_center.locale = (u.default_locale)::bpchar))))
                                   LEFT JOIN site_i18n i18n_site ON (((ss.id = i18n_site.site_id) AND ((i18n_site.type)::text = 'site_name'::text) AND (i18n_site.locale = (ss.main_language)::bpchar))))
                                 WHERE ((u.user_type)::text = '2'::text);
COMMENT ON VIEW v_sys_site_manage IS '站点管理 --tom';
