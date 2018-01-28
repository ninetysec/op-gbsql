-- auto gen by cherry 2018-01-15 18:00:04

DROP view IF EXISTS v_site_master_manage;
CREATE OR REPLACE VIEW "v_site_master_manage" AS
 SELECT su.id,
    su.username,
    su.nickname,
    su.sex,
    ( SELECT count(1) AS count
           FROM sys_site
          WHERE (sys_site.sys_user_id = su.id)) AS site_num,
    su.status,
    su.last_login_time,
    su.create_time,
    ctct.user_id,
    ctct.mobile_phone,
    ctct.mail,
    ctct.qq,
    ctct.msn,
    ctct.skype,
    ue.referrals,
    su.memo,
    su.last_login_ip,
    su.birthday,
    su.constellation,
    su.user_type,
    su.site_id,
    su.owner_id,
    su.freeze_type,
    su.freeze_start_time,
    su.freeze_end_time,
    ss.name,
    su.last_login_ip_dict_code,
    su.password,
    su.default_timezone
   FROM (((sys_user su
     LEFT JOIN user_extend ue ON ((su.id = ue.id)))
     LEFT JOIN sys_site ss ON ((su.site_id = ss.id)))
     LEFT JOIN ( SELECT ct.user_id,
            ct.mobile_phone,
            ct.mail,
            ct.qq,
            ct.msn,
            ct.skype
           FROM crosstab('SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON ((su.id = ctct.user_id)));


COMMENT ON VIEW "v_site_master_manage" IS '站长管理 --tom edit by younger';

DROP view IF EXISTS v_sys_site_manage;
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
    ds.idc,
COALESCE(ss.has_use_profit)*100/(ss.max_profit+COALESCE(ss.credit_line)) profit_percent
   FROM ((((sys_user u
     LEFT JOIN sys_site ss ON ((u.id = ss.sys_user_id)))
     JOIN sys_datasource ds ON ((ss.id = ds.id)))
     LEFT JOIN site_i18n i18n_center ON (((u.site_id = i18n_center.site_id) AND ((i18n_center.type)::text = 'site_name'::text) AND (i18n_center.locale = (u.default_locale)::bpchar))))
     LEFT JOIN site_i18n i18n_site ON (((ss.id = i18n_site.site_id) AND ((i18n_site.type)::text = 'site_name'::text) AND (i18n_site.locale = (ss.main_language)::bpchar))))
  WHERE ((u.user_type)::text = '2'::text);

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';
