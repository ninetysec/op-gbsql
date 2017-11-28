-- auto gen by bruce 2016-06-05 15:21:52
DROP VIEW IF EXISTS v_site_contract_scheme;
CREATE OR REPLACE VIEW v_site_contract_scheme AS
	SELECT cs."id",
		   cs.ensure_consume,
		   cs.maintenance_charges,
		   cs.status,
		   cs.create_time,
		   cs.update_time,
		   ss.center_id,
		   (SELECT count(1) FROM contract_api WHERE contract_scheme_id = cs.id AND is_assume = true) as t_num,
		   (SELECT count(1) FROM contract_api WHERE contract_scheme_id = cs.id AND is_assume = false) as f_num,
		   (SELECT min(coa.ratio) FROM contract_api ca LEFT JOIN contract_occupy_api coa ON ca.api_id = coa.api_id
			 WHERE ca.contract_scheme_id = cs.id) as minratio,
		   (SELECT id FROM contract_favourable WHERE contract_scheme_id = cs.id AND favourable_type::text = '1'::text LIMIT 1) as type_1_id,
		   (SELECT id FROM contract_favourable WHERE contract_scheme_id = cs.id AND favourable_type::text = '2'::text LIMIT 1) as type_2_id,
		   (SELECT count(1) FROM sys_site WHERE site_net_scheme_id = cs.id AND parent_id = ss.center_id) as site_choose_num,
		   (SELECT max(coa.ratio) FROM contract_api ca, contract_occupy_api coa, api api
			 WHERE ca.api_id = coa.api_id AND api.id = ca.api_id AND api.status::text <> 'disable'::text AND ca.contract_scheme_id = cs.id) as maxratio
	  FROM contract_scheme cs JOIN site_contract_scheme ss ON cs.id = ss.contract_scheme_id;

COMMENT ON VIEW v_site_content_check IS '运营商使用的包网方案--Tom';

DROP VIEW IF EXISTS v_sys_role;
CREATE OR REPLACE VIEW v_sys_role AS
	SELECT sr."id",
	       sr."name",
		   sr.site_id,
	       sr.subsys_code,
	       sr.built_in,
	       COALESCE(user_count, 0) as user_count
	  FROM sys_role sr
	  LEFT JOIN (SELECT role_id,
	                    count(1) as user_count
	               FROM sys_user_role
	              GROUP BY role_id) user_role ON role_id = sr."id";

COMMENT ON VIEW v_sys_role IS '角色视图 - jeff';

DROP VIEW IF EXISTS v_site_content_check;
CREATE OR REPLACE VIEW v_site_content_check AS
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
        su.username as master_name,
        su.user_type,
        ss.name     as site_name,
        ss.logo_path,
        ss.site_classify_key,
        ss.main_language,
		ss.parent_id
   FROM site_content_check sc, sys_user su, sys_site ss
  WHERE sc.site_id = ss.id AND ss.sys_user_id = su.id;

COMMENT ON VIEW v_site_content_check IS '运营商使用的包网方案--Tom';

UPDATE sys_role SET site_id = -1 WHERE site_id IS NULL;
UPDATE sys_user SET default_timezone = 'GMT+08:00' WHERE default_timezone IS NULL;
INSERT INTO sys_dict ("module", dict_type, dict_code, order_num, remark, parent_code, active)
	SELECT 'common', 'fund_type', 'wechatpay_scan', '12', '资金类型：微信扫码支付', NULL, 't'
	WHERE 'wechatpay_scan' not in(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type');

INSERT INTO sys_dict ("module", dict_type, dict_code, order_num, remark, parent_code, active)
	SELECT 'common', 'fund_type', 'alipay_scan', '13', '资金类型：支付宝扫码支付', NULL, 't'
	WHERE 'alipay_scan' not in(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type');

INSERT INTO sys_dict ("module", dict_type, dict_code, order_num, remark, parent_code, active)
	SELECT 'common', 'fund_type', 'wechatpay_fast', '14', '资金类型：微信极速存款', NULL, 't'
	WHERE 'wechatpay_fast' not in(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type');

INSERT INTO sys_dict ("module", dict_type, dict_code, order_num, remark, parent_code, active)
	SELECT 'common', 'fund_type', 'alipay_fast', '15', '资金类型：支付宝极速存款', NULL, 't'
	WHERE 'alipay_fast' not in(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type');

DROP VIEW IF EXISTS v_sport_team;
CREATE OR REPLACE VIEW "v_sport_team" AS
 SELECT a.id,
    a.team_logo,
    b.team_name,
    b.local,
    a.team_type
   FROM (sport_team a
     LEFT JOIN sport_team_i18n b ON ((b.sport_team_id = a.id)));

COMMENT ON VIEW "v_sport_team" IS '球队管理 add by eagle';