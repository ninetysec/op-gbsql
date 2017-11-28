-- auto gen by cheery 2015-11-27 15:58:07
DROP VIEW IF EXISTS "v_sys_site_domain";

select redo_sqls($$
    ALTER TABLE "sys_domain" ADD COLUMN "is_temp" bool;
$$);

COMMENT ON COLUMN "sys_domain"."is_temp" IS '是否是临时域名';

CREATE OR REPLACE VIEW "v_sys_site_domain" AS
  SELECT dom.id,
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
    dom.is_temp,
    usr.site_id AS center_id,
    dom.agent_id,
    dom.resolve_status,
    site.logo_path,
    site.parent_id AS site_parent_id
  FROM sys_site site,
    sys_domain dom,
    sys_user usr
  WHERE (((dom.sys_user_id = usr.id) AND (usr.id = site.sys_user_id)) AND (site.id = dom.site_id));