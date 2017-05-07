-- auto gen by longer 2015-11-17 09:20:45

--用户站点表
CREATE OR REPLACE VIEW v_sys_site_user AS SELECT
                                                   site.id AS id,
                                                   site.name as site_name,
                                                   usr.id as sys_user_id,
                                                   usr.username as username,
                                                   usr.subsys_code as subsys_code,
                                                   usr.site_id AS center_id,
                                                   ext.name as user_extend_name
                                                 FROM sys_site site,
                                                   sys_user usr LEFT JOIN user_extend ext on usr.id = ext.id
                                                 WHERE site.sys_user_id = usr.id ;

COMMENT ON VIEW v_sys_site_user is '用户站点表--Longer';



