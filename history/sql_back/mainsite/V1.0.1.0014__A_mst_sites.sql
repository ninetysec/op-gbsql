-- auto gen by longer 2015-09-09 15:36:51

--站点代码4位长度
select redo_sqls($$
  alter table mst_sites add COLUMN code CHARACTER VARYING(4);
  CREATE UNIQUE INDEX uq_mst_sites_code on mst_sites(code);
$$);
COMMENT ON COLUMN mst_sites.code IS '站点代码';
COMMENT ON COLUMN mst_sites.timezone IS '站点时区';

--创建唯一索引

--默认运营商siteId=2
update mst_domain set site_id = 2 where subsys_code = 'ccenter';

drop view v_domain_master;
--视图添加：站点代码
CREATE OR REPLACE VIEW v_domain_master AS
  SELECT dom.id, dom.master_id, dom.domain, dom.is_default, dom.is_enable, dom.is_deleted, dom.sort, dom.site_id, dom.subsys_code,
    site.timezone as time_zone, mst.center_id, site.main_language AS site_locale, site.code as site_code
  FROM mst_domain dom, mst_master mst, mst_sites site
  WHERE dom.master_id = mst.id AND mst.id = site.master_id AND dom.subsys_code::text = 'mcenter'::text
  UNION ALL
  SELECT dom.id, dom.master_id, dom.domain, dom.is_default, dom.is_enable, dom.is_deleted, dom.sort, dom.site_id, dom.subsys_code,
    site.timezone as time_zone, site.id AS center_id, site.main_language AS site_locale, site.code as site_code
  FROM mst_domain dom, mst_sites site
  WHERE dom.site_id = site.id AND (dom.subsys_code::text = ANY (ARRAY['ccenter'::character varying, 'boss'::character varying]::text[]));

ALTER TABLE v_domain_master
OWNER TO postgres;

--默认boss
insert into mst_sites(id, master_id, name, theme, sso_theme, status, is_buildin, postfix, short_name,code)
    SELECT 0,null,'BOSS',null,'boss',null,true,null,'BOSS','0000'
      where not exists( select id from mst_sites t where t.id = 0 );

--默认运营商
insert into mst_sites(id, master_id, name, theme, sso_theme, status, is_buildin, postfix, short_name,code)
  select 2,null,'默认运营商',null,'ccenter',null,true,null,'Company','0002'
  where not exists( select id from mst_sites t where t.id = 2 );

--设置测试站点代码
update mst_sites set code = '0001' where id = 1;

--设置boss,默认运营商时区，语言
update mst_sites set timezone = 'GMT+8', main_language = 'zh_CN' where id = 0;
update mst_sites set timezone = 'GMT-5', main_language = 'zh_TW' where id = 1;
update mst_sites set timezone = 'GMT-5', main_language = 'zh_TW' where id = 2;



CREATE OR REPLACE VIEW v_domain_theme AS
  SELECT dom.id, dom.master_id, dom.domain, site.name, site.sso_theme
  FROM mst_domain dom, mst_sites site
  WHERE dom.master_id = site.master_id AND dom.is_enable = true AND dom.subsys_code::text = 'mcenter'::text
  UNION ALL
  SELECT dom.id, dom.master_id, dom.domain, site.name, site.sso_theme
  FROM mst_domain dom, mst_sites site
  WHERE dom.site_id = site.id AND dom.is_enable = true AND (dom.subsys_code::text = 'ccenter'::text OR dom.subsys_code::text = 'boss'::text);

ALTER TABLE v_domain_theme
OWNER TO postgres;

--合并　sys_site 到 mst_sites
drop table IF EXISTS sys_site;

select redo_sqls($$
alter TABLE mst_domain1  ALTER COLUMN id set DEFAULT null;
alter SEQUENCE "mst_domain_id_seq" OWNED BY "mst_domain"."id";
DROP table IF EXISTS mst_domain1;
$$);


