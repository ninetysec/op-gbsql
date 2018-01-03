-- auto gen by tom 2015-11-23 18:13:49

SELECT redo_sqls($$
  alter table sys_site add COLUMN  site_net_scheme_id INTEGER;
  alter table sys_site add COLUMN  max_profit REAL;
$$);

COMMENT ON COLUMN sys_site.site_net_scheme_id IS '包网方案ID';
COMMENT ON COLUMN sys_site.max_profit IS '盈利上限';

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
    su.username,
    ss.site_classify_key,
    ss.site_net_scheme_id,
    ss.max_profit,
    sns.name AS netscheme,
    su.owner_id,
    su.site_id AS center_id
   FROM ((sys_site ss
     JOIN sys_user su ON ((ss.sys_user_id = su.id)))
     LEFT JOIN site_net_scheme sns ON ((ss.site_net_scheme_id = sns.id)))
  WHERE ((su.user_type)::text = ANY (ARRAY['2'::text, '21'::text]));

ALTER TABLE "v_sys_site_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';