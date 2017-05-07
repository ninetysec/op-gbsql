-- auto gen by tom 2015-12-27 09:57:00
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
          WHERE (site_contract_scheme.center_id = b.id)) AS scheme_num,
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

ALTER TABLE "v_platform_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_platform_manage" IS '总控平台下平台管理';