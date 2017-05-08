-- auto gen by tony 2017-05-08 12:06:22
-- auto gen by tony 2017-05-08 10:13:06
update sys_resource set url='vSysSiteManage/list.html' where id=306;
update sys_resource set status=false where id=30601;
Drop view if EXISTS "v_sys_site_manage";
Drop view if EXISTS "v_site_manage";
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
    i18n.value AS parent_name,
    ds.name AS site_name,
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
    i18n.locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE ((m.site_id = ss.id) AND ((m.subsys_code)::text = 'msites'::text) AND ((m.page_url)::text = '/'::text))
         LIMIT 1) AS domain,
    ss.remark,
    ss.belong_to_idc
   FROM  (((sys_user u
     LEFT JOIN sys_site ss ON ((u.id = ss.sys_user_id)))
     LEFT JOIN sys_datasource ds ON ((ss.id = ds.id)))
     LEFT JOIN site_i18n i18n ON (((u.site_id = i18n.site_id) AND ((i18n.type)::text = 'site_name'::text))))
  WHERE ((u.user_type)::text = '2'::text);


COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';