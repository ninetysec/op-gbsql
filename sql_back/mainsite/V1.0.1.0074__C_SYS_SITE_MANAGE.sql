-- auto gen by tom 2015-11-16 16:27:03
create extension IF NOT EXISTS tablefunc;

DROP VIEW IF EXISTS v_sys_site_manage;

CREATE OR REPLACE VIEW "v_sys_site_manage" AS
 SELECT ss.id,
    ss.sys_user_id,
    ss.name,
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
    su.username
   FROM (sys_site ss
     JOIN sys_user su ON ((ss.sys_user_id = su.id)));

ALTER TABLE "v_sys_site_manage" OWNER TO "postgres";

COMMENT ON VIEW v_sys_site_manage  IS '站点管理 --tom';