-- auto gen by tony 2017-04-10 09:08:30
CREATE OR REPLACE VIEW v_site_master AS
 SELECT u.id AS userid,
    u.username,
    u.site_id AS parent_id,
    i18n.value AS parent_name,
    site.id AS siteid,
    ds.name AS site_name,
    site.timezone,
    site.code,
    site.max_profit,
    site.status,
    ds.username AS db,
    i18n.locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE ((m.site_id = site.id) AND ((m.subsys_code)::text = 'msites'::text) AND ((m.page_url)::text = '/'::text))
         LIMIT 1) AS domain,
    site.remark,
    site.belong_to_idc
   FROM (((sys_user u
     LEFT JOIN sys_site site ON ((u.id = site.sys_user_id)))
     LEFT JOIN sys_datasource ds ON ((site.id = ds.id)))
     LEFT JOIN site_i18n i18n ON (((u.site_id = i18n.site_id) AND ((i18n.type)::text = 'site_name'::text))))
  WHERE ((u.user_type)::text = '2'::text);

COMMENT ON VIEW v_site_master IS '站长管理视图';