-- auto gen by cherry 2016-12-07 11:45:06
select redo_sqls($$
    ALTER TABLE sys_site ADD COLUMN remark text;
  $$);
COMMENT ON COLUMN sys_site.remark IS '备注';

drop view if EXISTS v_site_master;

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
          WHERE ((m.site_id = site.id) AND ((m.subsys_code)::text = 'msites'::text))
         LIMIT 1) AS domain,
    site.remark
   FROM (((sys_user u
     LEFT JOIN sys_site site ON ((u.id = site.sys_user_id)))
     LEFT JOIN sys_datasource ds ON ((site.id = ds.id)))
     LEFT JOIN site_i18n i18n ON (((u.site_id = i18n.site_id) AND ((i18n.type)::text = 'site_name'::text))))
  WHERE ((u.user_type)::text = '2'::text);

COMMENT ON VIEW v_site_master IS '站长管理视图';