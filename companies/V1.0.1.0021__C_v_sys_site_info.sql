-- auto gen by cherry 2016-02-21 15:03:41
DROP VIEW IF EXISTS v_sys_site_info;
CREATE OR REPLACE VIEW v_sys_site_info as
SELECT ss."id"			as siteid,
	   ss."name"		as sitename,
	   um."id"			as masterid,
	   um.username		as mastername,
	   um.user_type		as usertype,
	   um.subsys_code	as subsyscode,
	   uc."id"			as operationid,
	   uc.username		as operationname,
	   uc.user_type		as operationusertype,
	   uc.subsys_code	as operationsubsyscode
  FROM sys_site ss
  LEFT JOIN sys_user um ON ss.sys_user_id = um."id"
  LEFT JOIN sys_user uc ON ss.parent_id = uc."id"
 WHERE um.user_type = '2'
   AND ss."name" IS NOT NULL
   AND (uc.user_type = '1' OR uc.user_type = '11')
 ORDER BY ss."id";

ALTER TABLE v_sys_site_info OWNER TO postgres;
COMMENT ON VIEW v_sys_site_info IS '站点信息视图 — Fly';