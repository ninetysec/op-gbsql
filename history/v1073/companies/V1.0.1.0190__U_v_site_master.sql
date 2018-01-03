-- auto gen by bruce 2016-10-04 17:36:17
DROP VIEW if EXISTS v_site_master;
CREATE OR REPLACE VIEW "v_site_master" AS
SELECT u.id userid,u.username,u.site_id parent_id,i18n."value" parent_name,site. ID siteid,ds. NAME site_name,site.timezone timezone,site.code,site.max_profit,site.status status,ds.username db,i18n.locale FROM(((sys_user u LEFT OUTER JOIN sys_site site ON u. id = site.sys_user_id) LEFT OUTER JOIN sys_datasource ds ON site.id = ds. id) LEFT OUTER JOIN site_i18n i18n ON u.site_id=i18n.site_id AND i18n.type='site_name') WHERE u.user_type='2' ;
COMMENT ON VIEW "v_site_master" IS '站长管理视图';