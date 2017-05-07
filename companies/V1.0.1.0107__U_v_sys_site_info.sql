-- auto gen by bruce 2016-06-06 11:32:03
DROP VIEW IF EXISTS v_sys_site_info;
CREATE OR REPLACE VIEW v_sys_site_info AS
	SELECT s.siteid,
		   (SELECT si.value FROM site_i18n si WHERE si.site_id = s.siteid AND si.locale = s.main_language AND si.type = 'site_name' AND si.module = 'setting' AND si.key = 'name' LIMIT 1) as sitename,
		   s.sys_user_id 	masterid,
		   sm.username 		mastername,
		   sm.user_type		usertype,
		   sm.subsys_code	subsyscode,
		   s.parent_user_id	operationid,
		   sc.username 		operationname,
		   sc.user_type 	operationusertype,
		   sc.subsys_code   operationsubsyscode
	  FROM (SELECT s1. ID siteid,
				   s1.main_language,
				   s1.parent_id,
				   s1.sys_user_id,
				   s2.sys_user_id parent_user_id
			  FROM sys_site s1, sys_site s2
			 WHERE s1.parent_id = s2."id") s
	  LEFT JOIN sys_user sm ON s.sys_user_id = sm."id"
	  LEFT JOIN sys_user sc on s.parent_user_id = sc.id ORDER BY s.siteid;

COMMENT ON VIEW v_sys_site_info IS '站点信息视图 — Fei';