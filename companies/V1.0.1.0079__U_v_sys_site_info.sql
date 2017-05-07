-- auto gen by fei 2016-04-15 21:04:35

DROP VIEW IF EXISTS v_sys_site_info;
CREATE OR REPLACE VIEW v_sys_site_info AS
 SELECT ss.id AS siteid,
        (SELECT si.value
           FROM site_i18n si
          WHERE si.site_id 		= ss.id
            AND si.locale 		= ss.main_language
            AND si.type::text 	= 'site_name'
            AND si.module::text = 'setting'
            AND si.key::text 	= 'name'
          LIMIT 1) 		AS sitename,
    	um.id 			AS masterid,
    	um.username 	AS mastername,
    	um.user_type 	AS usertype,
    	um.subsys_code 	AS subsyscode,
    	uc.id 			AS operationid,
    	uc.username 	AS operationname,
    	uc.user_type 	AS operationusertype,
    	uc.subsys_code 	AS operationsubsyscode
 FROM sys_site ss
 LEFT JOIN sys_user um ON ss.sys_user_id = um.id
 LEFT JOIN sys_user uc ON ss.parent_id = uc.id
WHERE um.user_type = '2'
  AND uc.user_type = '1'
   OR uc.user_type = '11'
ORDER BY ss.id;

ALTER TABLE v_sys_site_info OWNER TO "gb-companies";
COMMENT ON VIEW v_sys_site_info IS '站点信息视图 — Fly';
