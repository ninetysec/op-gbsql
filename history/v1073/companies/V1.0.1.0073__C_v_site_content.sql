-- auto gen by admin 2016-04-11 21:59:59
drop view if EXISTS v_site_content;
CREATE OR REPLACE VIEW "v_site_content" AS

 SELECT a.id,

    a.site_id,

    a.pending_check,

    a.audit_check,

    a.last_publish_time,

    b.name AS site_name,

    c.username AS master_name,

    b.logo_path,

    b.site_classify_key,

    b.main_language,

    c.user_type,

    c.id AS master_id,

    b.parent_id

   FROM site_content a,

    sys_site b,

    sys_user c

  WHERE ((a.site_id = b.id) AND (b.sys_user_id = c.id));

COMMENT ON VIEW "v_site_content" IS '内容审核视图--river';


DROP VIEW  if EXISTS v_platform_manage;

CREATE OR REPLACE VIEW "v_platform_manage" AS
 SELECT a.id,
    a.sys_user_id,
    a.name,
    a.status,
    a.logo_path,
    a.opening_time,
    b.username,
    ( SELECT count(1) AS count
           FROM site_contract_scheme
          WHERE (site_contract_scheme.center_id = a.id)) AS scheme_num,
    a.maintain_start_time,
    a.maintain_end_time,
    ( SELECT c.username
           FROM sys_user c
          WHERE (c.id = a.maintain_operate_id)) AS operator,
    a.maintain_operate_time,
    a.timezone
   FROM (sys_site a
     JOIN sys_user b ON ((a.sys_user_id = b.id)))
  WHERE (((b.user_type)::text = '1'::text) AND ((b.subsys_code)::text = 'ccenter'::text));

COMMENT ON VIEW "v_platform_manage" IS '总控平台下平台管理';


INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
select 'ysb', '2', '1200', '1', '1200 px  易胜博模板', NULL, 'images/ysb.png'
WHERE 'ysb' not in (SELECT code FROM site_template where code='ysb');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'williamHill', '2', '1200', '1', '1200 px  威廉希尔模板', NULL, 'images/williamHill.png'
where 'williamHill' not in(SELECT code FROM site_template where code='williamHill');