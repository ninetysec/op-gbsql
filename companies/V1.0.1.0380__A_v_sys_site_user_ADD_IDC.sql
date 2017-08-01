-- auto gen by Water 2017-08-01 20:04:48
--增加idc
CREATE or REPLACE VIEW v_sys_site_user AS SELECT site.id,
                                 site.name AS site_name,
                                 usr.id AS sys_user_id,
                                 site.status,
                                 usr.username,
                                 usr.subsys_code,
                                 usr.site_id AS center_id,
                                 site.parent_id AS site_parent_id,
                                 site.main_language AS site_locale,
                                 site.timezone,
                                 ds.idc
                               FROM sys_site site,
                                 sys_user usr,
                                 sys_datasource ds
                               WHERE (site.sys_user_id = usr.id)
                                     and (site.id = ds.id) ;
