-- auto gen by admin 2016-07-05 14:13:02
DROP VIEW IF EXISTS v_platform_manage;
CREATE OR REPLACE VIEW v_platform_manage AS
 SELECT a.id,
        a.sys_user_id,
        a.name,
        a.status,
        a.logo_path,
        a.opening_time,
        b.username,
        (SELECT count(1) FROM site_contract_scheme WHERE (site_contract_scheme.center_id = a.id)) as scheme_num,
        a.maintain_start_time,
        a.maintain_end_time,
        (SELECT c.username FROM sys_user c WHERE c.id = a.maintain_operate_id) as operator,
        a.maintain_operate_time,
        a.maintain_operate_id as operate_id,
        a.timezone
   FROM sys_site a JOIN sys_user b ON a.sys_user_id = b.id
  WHERE b.user_type = '1' AND b.subsys_code = 'ccenter';

COMMENT ON VIEW v_platform_manage IS '总控平台下平台管理';