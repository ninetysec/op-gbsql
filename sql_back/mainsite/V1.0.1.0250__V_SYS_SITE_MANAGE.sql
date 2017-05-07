-- auto gen by tom 2016-01-25 17:22:01
DROP VIEW IF EXISTS v_sys_site_manage;
CREATE OR REPLACE VIEW "v_sys_site_manage" AS
 SELECT ss.id,
    ss.sys_user_id,
    ss.theme,
    ss.sso_theme,
    ss.status,
    ss.is_buildin,
    ss.postfix,
    ss.short_name,
    ss.main_currency,
    ss.main_language,
    ss.web_site,
    ss.opening_time,
    ss.timezone,
    ss.traffic_statistics,
    ss.code,
    ss.logo_path,
    su.username,
    ss.site_classify_key,
    ss.site_net_scheme_id,
    ss.max_profit,
    su.owner_id,
    su.site_id AS center_id,
    ss.deposit,
    ss.template_code,
    ss.import_players_time,
    ss.maintain_start_time,
    ss.maintain_end_time
   FROM (sys_site ss
     JOIN sys_user su ON ((ss.sys_user_id = su.id)))
  WHERE ((su.user_type)::text = '2'::text);

ALTER TABLE "v_sys_site_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';