-- auto gen by longer 2015-10-26 13:47:41

CREATE OR REPLACE VIEW v_sys_site_domain AS SELECT dom.id,
                                                     site.id AS site_id,
                                                     site.name,
                                                     site.timezone AS time_zone,
                                                     site.main_language AS site_locale,
                                                     site.code AS site_code,
                                                     dom.id AS domain_id,
                                                     dom.sys_user_id AS master_id,
                                                     dom.domain,
                                                     dom.is_default,
                                                     dom.is_enable,
                                                     dom.is_deleted,
                                                     dom.sort,
                                                     dom.subsys_code,
                                                     usr.site_id AS center_id,
                                                     dom.agent_id,
                                                     dom.is_resolve,
                                                     site.logo_path
                                                   FROM sys_site site,
                                                     sys_domain dom,
                                                     sys_user usr
                                                   WHERE ((dom.sys_user_id = usr.id) AND (usr.id = site.sys_user_id));