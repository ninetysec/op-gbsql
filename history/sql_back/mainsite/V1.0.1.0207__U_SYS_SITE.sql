-- auto gen by tom 2016-01-05 11:41:27

select redo_sqls($$
    ALTER TABLE "sys_site" ALTER COLUMN "name" DROP NOT NULL;
  $$);

  DROP VIEW IF EXISTS v_sys_site_manage;

  CREATE OR REPLACE VIEW "v_sys_site_manage" AS
 SELECT ss.id,
    ss.sys_user_id,
    sn.value AS name,
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
    scs.netscheme,
    scs.locale,
    su.owner_id,
    su.site_id AS center_id,
    ss.deposit,
    ss.template_code
   FROM (((sys_site ss
     JOIN ( SELECT site_i18n.id,
            site_i18n.module,
            site_i18n.type,
            site_i18n.key,
            site_i18n.locale,
            site_i18n.value,
            site_i18n.site_id,
            site_i18n.remark,
            site_i18n.default_value,
            site_i18n.built_in
           FROM site_i18n
          WHERE ((((site_i18n.module)::text = 'setting'::text) AND ((site_i18n.type)::text = 'site_name'::text)) AND ((site_i18n.key)::text = 'name'::text))) sn ON ((ss.id = sn.site_id)))
     JOIN sys_user su ON ((ss.sys_user_id = su.id)))
     JOIN ( SELECT a.id,
            c.value AS netscheme,
            c.locale
           FROM ((site_contract_scheme a
             JOIN contract_scheme b ON ((a.contract_scheme_id = b.id)))
             JOIN ( SELECT site_i18n.id,
                    site_i18n.module,
                    site_i18n.type,
                    site_i18n.key,
                    site_i18n.locale,
                    site_i18n.value,
                    site_i18n.site_id,
                    site_i18n.remark,
                    site_i18n.default_value,
                    site_i18n.built_in
                   FROM site_i18n
                  WHERE (((site_i18n.module)::text = 'boss'::text) AND ((site_i18n.type)::text = 'contract_scheme'::text))) c ON ((b.id = (c.key)::integer)))) scs ON ((ss.site_net_scheme_id = scs.id)))
  WHERE ((su.user_type)::text = ANY (ARRAY['2'::text, '21'::text]));

ALTER TABLE "v_sys_site_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';