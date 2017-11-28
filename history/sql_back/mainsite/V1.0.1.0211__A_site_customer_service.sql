-- auto gen by cherry 2016-01-06 14:57:36
  select redo_sqls($$
    ALTER TABLE "site_customer_service" ADD COLUMN "built_in" bool;
  $$);

INSERT INTO "site_customer_service" ( "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in")
SELECT  '1', 'K001', '默认客服', '', 't', '2015-11-17 09:11:03.847', '241', 't'
WHERE 'K001'  NOT in (SELECT code FROM site_customer_service WHERE name='默认客服' AND site_id='1' );

DROP VIEW IF EXISTS  v_sys_site_user ;
CREATE VIEW v_sys_site_user as
 SELECT site.id,
    site.name AS site_name,
    usr.id AS sys_user_id,
    site.status,
    usr.username,
    usr.subsys_code,
    usr.site_id AS center_id,
    site.parent_id AS site_parent_id,
    site.main_language AS site_locale
   FROM sys_site site,
    sys_user usr
  WHERE (site.sys_user_id = usr.id);


