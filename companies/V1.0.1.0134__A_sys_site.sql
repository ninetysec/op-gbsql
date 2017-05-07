-- auto gen by cherry 2016-07-26 21:05:39
drop view if EXISTS v_platform_manage;

drop view if EXISTS v_site_content_check;

drop view if EXISTS v_sys_site_user;

drop view if EXISTS v_site_contract_scheme;

drop view if EXISTS v_player_recharge;

drop view if EXISTS v_sys_user_operators;

drop view if EXISTS v_site_content;

drop view if EXISTS v_sys_site_manage;

drop view if EXISTS v_sys_site_domain;

drop view if EXISTS v_site_contract_scheme;



ALTER TABLE "sys_site" ALTER COLUMN "traffic_statistics" TYPE varchar(1000);



CREATE OR REPLACE VIEW "v_platform_manage" AS

 SELECT a.id,

    a.sys_user_id,

    a.name,

    a.status,

    a.logo_path,

    a.opening_time,

    b.username,

    ( SELECT count(1) AS count

           FROM site_contract_scheme

          WHERE (site_contract_scheme.center_id = a.id)) AS scheme_num,

    a.maintain_start_time,

    a.maintain_end_time,

    ( SELECT c.username

           FROM sys_user c

          WHERE (c.id = a.maintain_operate_id)) AS operator,

    a.maintain_operate_time,

    a.maintain_operate_id AS operate_id,

    a.timezone

   FROM (sys_site a

     JOIN sys_user b ON ((a.sys_user_id = b.id)))

  WHERE (((b.user_type)::text = '1'::text) AND ((b.subsys_code)::text = 'ccenter'::text));



COMMENT ON VIEW "v_platform_manage" IS '总控平台下平台管理';


CREATE OR REPLACE VIEW "v_site_content_check" AS

 SELECT sc.id,

    sc.site_id,

    sc.content_type,

    sc.content_name,

    sc.publish_time,

    sc.check_user_id,

    sc.check_status,

    sc.check_time,

    sc.reason_title,

    sc.reason_content,

    sc.source_id,

    su.username AS master_name,

    su.user_type,

    ss.name AS site_name,

    ss.logo_path,

    ss.site_classify_key,

    ss.main_language,

    ss.parent_id

   FROM site_content_check sc,

    sys_user su,

    sys_site ss

  WHERE ((sc.site_id = ss.id) AND (ss.sys_user_id = su.id));



COMMENT ON VIEW "v_site_content_check" IS '运营商使用的包网方案--Tom';





CREATE OR REPLACE VIEW "v_sys_site_user" AS

 SELECT site.id,

    site.name AS site_name,

    usr.id AS sys_user_id,

    site.status,

    usr.username,

    usr.subsys_code,

    usr.site_id AS center_id,

    site.parent_id AS site_parent_id,

    site.main_language AS site_locale

   FROM sys_site site,

    sys_user usr

  WHERE (site.sys_user_id = usr.id);







CREATE OR REPLACE VIEW "v_site_contract_scheme" AS

 SELECT cs.id,

    cs.ensure_consume,

    cs.maintenance_charges,

    cs.status,

    cs.create_time,

    cs.update_time,

    ss.center_id,

    ( SELECT count(1) AS count

           FROM contract_api

          WHERE ((contract_api.contract_scheme_id = cs.id) AND (contract_api.is_assume = true))) AS t_num,

    ( SELECT count(1) AS count

           FROM contract_api

          WHERE ((contract_api.contract_scheme_id = cs.id) AND (contract_api.is_assume = false))) AS f_num,

    ( SELECT min(coa.ratio) AS min

           FROM (contract_api ca

             LEFT JOIN contract_occupy_api coa ON ((ca.api_id = coa.api_id)))

          WHERE (ca.contract_scheme_id = cs.id)) AS minratio,

    ( SELECT contract_favourable.id

           FROM contract_favourable

          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '1'::text))

         LIMIT 1) AS type_1_id,

    ( SELECT contract_favourable.id

           FROM contract_favourable

          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '2'::text))

         LIMIT 1) AS type_2_id,

    ( SELECT count(1) AS count

           FROM sys_site

          WHERE ((sys_site.site_net_scheme_id = cs.id) AND (sys_site.parent_id = ss.center_id))) AS site_choose_num,

    ( SELECT max(coa.ratio) AS max

           FROM contract_api ca,

            contract_occupy_api coa,

            api api

          WHERE ((ca.api_id = coa.api_id) AND (api.id = ca.api_id) AND ((api.status)::text <> 'disable'::text) AND (ca.contract_scheme_id = cs.id))) AS maxratio

   FROM (contract_scheme cs

     JOIN site_contract_scheme ss ON ((cs.id = ss.contract_scheme_id)));







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



COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';





CREATE OR REPLACE VIEW "v_player_recharge" AS

 SELECT site.id,

    site.name AS site_name,

    usr.id AS sys_user_id,

    site.status,

    usr.username,

    usr.subsys_code,

    usr.site_id AS center_id,

    site.parent_id AS site_parent_id,

    site.main_language AS site_locale

   FROM sys_site site,

    sys_user usr

  WHERE (site.sys_user_id = usr.id);







CREATE OR REPLACE VIEW "v_sys_user_operators" AS

 SELECT t2.name,

    t3.referrals,

    t1.id,

    t1.username,

    t1.birthday,

    t1.sex,

    t1.create_time,

    t1.last_login_ip,

    t1.last_login_time,

    t1.last_login_ip_dict_code,

    t1.constellation,

    t1.memo,

    t1.nickname,

    t1.status,

    t1.freeze_end_time,

    t2.id AS site_id,

    t4.contract_scheme_ids

   FROM (((sys_user t1

     LEFT JOIN sys_site t2 ON ((t1.id = t2.sys_user_id)))

     LEFT JOIN user_extend t3 ON ((t1.id = t3.id)))

     LEFT JOIN ( SELECT site_contract_scheme.center_id,

            string_agg((site_contract_scheme.contract_scheme_id || ''::text), ','::text) AS contract_scheme_ids

           FROM site_contract_scheme

          GROUP BY site_contract_scheme.center_id) t4 ON ((t4.center_id = t2.id)))

  WHERE ((t1.user_type)::text = '1'::text);





COMMENT ON VIEW "v_sys_user_operators" IS '运营商视图实体 -- cherry';





CREATE OR REPLACE VIEW "v_site_content" AS

 SELECT a.id,

    a.site_id,

    a.pending_check,

    a.audit_check,

    a.last_publish_time,

    b.name AS site_name,

    c.username AS master_name,

    b.logo_path,

    b.site_classify_key,

    b.main_language,

    c.user_type,

    c.id AS master_id,

    b.parent_id

   FROM site_content a,

    sys_site b,

    sys_user c

  WHERE ((a.site_id = b.id) AND (b.sys_user_id = c.id));



COMMENT ON VIEW "v_site_content" IS '内容审核视图--river';





CREATE OR REPLACE VIEW "v_sys_site_domain" AS

 SELECT dom.id,

    site.id AS site_id,

    site.name,

    site.timezone AS time_zone,

    site.main_language AS site_locale,

    site.code AS site_code,

    dom.id AS domain_id,

    dom.sys_user_id AS site_user_id,

    dom.domain,

    dom.is_default,

    dom.is_enable,

    dom.is_deleted,

    dom.sort,

    dom.subsys_code,

    dom.is_temp,

    dom.agent_id,

    dom.resolve_status,

    dom.create_time,

    site.logo_path,

    site.parent_id AS site_parent_id,

    site.status AS site_status,

    site.maintain_start_time,

    site.maintain_end_time,

    site.maintain_reason,

    site.template_code,

    site.theme,

    dom.page_url

   FROM sys_site site,

    sys_domain dom,

    sys_user usr

  WHERE ((dom.sys_user_id = usr.id) AND (usr.id = site.sys_user_id) AND (site.id = dom.site_id));





CREATE OR REPLACE VIEW "v_site_contract_scheme" AS

 SELECT cs.id,

    cs.ensure_consume,

    cs.maintenance_charges,

    cs.status,

    cs.create_time,

    cs.update_time,

    ss.center_id,

    ( SELECT count(1) AS count

           FROM contract_api

          WHERE ((contract_api.contract_scheme_id = cs.id) AND (contract_api.is_assume = true))) AS t_num,

    ( SELECT count(1) AS count

           FROM contract_api

          WHERE ((contract_api.contract_scheme_id = cs.id) AND (contract_api.is_assume = false))) AS f_num,

    ( SELECT min(coa.ratio) AS min

           FROM (contract_api ca

             LEFT JOIN contract_occupy_api coa ON ((ca.api_id = coa.api_id)))

          WHERE (ca.contract_scheme_id = cs.id)) AS minratio,

    ( SELECT contract_favourable.id

           FROM contract_favourable

          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '1'::text))

         LIMIT 1) AS type_1_id,

    ( SELECT contract_favourable.id

           FROM contract_favourable

          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '2'::text))

         LIMIT 1) AS type_2_id,

    ( SELECT count(1) AS count

           FROM sys_site

          WHERE ((sys_site.site_net_scheme_id = cs.id) AND (sys_site.parent_id = ss.center_id))) AS site_choose_num,

    ( SELECT max(coa.ratio) AS max

           FROM contract_api ca,

            contract_occupy_api coa,

            api api

          WHERE ((ca.api_id = coa.api_id) AND (api.id = ca.api_id) AND ((api.status)::text <> 'disable'::text) AND (ca.contract_scheme_id = cs.id))) AS maxratio

   FROM (contract_scheme cs

     JOIN site_contract_scheme ss ON ((cs.id = ss.contract_scheme_id)));

