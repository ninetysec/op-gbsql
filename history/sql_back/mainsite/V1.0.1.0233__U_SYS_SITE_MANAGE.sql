-- auto gen by tom 2016-01-14 10:26:38
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
    ss.import_players_time
   FROM (sys_site ss
     JOIN sys_user su ON ((ss.sys_user_id = su.id)))
  WHERE ((su.user_type)::text = '2'::text);

ALTER TABLE "v_sys_site_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_site_manage" IS '站点管理 --tom';

update site_i18n set site_id=0  where "module"='boss' and type='contract_scheme';

INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站长账号冻结','vMasterManage/freezeAccount.html','站点-站长管理',301,'',2,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'vMasterManage/freezeAccount.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vMasterManage/freezeAccount.html');

INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '取消站长账号冻结','vMasterManage/cancelAccountFreeze.html','站点-站长管理',301,'',3,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'vMasterManage/cancelAccountFreeze.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vMasterManage/cancelAccountFreeze.html');