-- auto gen by tom 2015-12-16 11:23:27
DROP view if EXISTS  v_platform_manage;
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
          WHERE (site_contract_scheme.center_id = b.id)) AS scheme_num
   FROM (sys_site a
     JOIN sys_user b ON ((a.sys_user_id = b.id)))
  WHERE (((b.user_type)::text = '1'::text) AND ((b.subsys_code)::text = 'ccenter'::text));

ALTER TABLE "v_platform_manage" OWNER TO "postgres";

comment on view v_platform_manage is '总控平台下平台管理';
