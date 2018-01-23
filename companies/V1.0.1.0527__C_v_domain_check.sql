-- auto gen by george 2018-01-22 15:26:22
DROP VIEW IF EXISTS v_domain_check;

CREATE OR REPLACE VIEW "v_domain_check" AS
 SELECT dm.name,
    dm.page_url,
    dm.sys_domain_url,
    dm.id,
    dm.site_id,
    dm.sys_domain_id,
    dm.content_type,
    dm.publish_time,
    dm.publish_user_id,
    dm.publish_user_name,
    dm.check_user_id,
    dm.check_status,
    dm.check_time,
    dm.reason_title,
    dm.reason_content,
    dm.domain,
    dm.code,
    dm.site_name,
    dm.domain_platform,
    dm.agent_id,
    dm.publish_user_type,
        CASE
            WHEN ((dm.check_status)::text = 'pending'::text) THEN 1
            WHEN ((dm.check_status)::text = 'process'::text) THEN 2
            WHEN ((dm.check_status)::text = 'success'::text) THEN 3
            ELSE 4
        END AS check_stauts_order,
    dm.resolve_status,
    dm.update_time,
    dm.subsys_code
   FROM ( SELECT sd.name,
            sd.page_url,
            sd.domain AS sys_domain_url,
            dc.id,
            sd.site_id,
            dc.sys_domain_id,
            dc.content_type,
            dc.publish_time,
            dc.publish_user_id,
            dc.publish_user_name,
            dc.check_user_id,
            dc.check_status,
            dc.check_time,
            dc.reason_title,
            dc.reason_content,
            sd.domain,
            dc.code,
            dc.site_name,
            dc.domain_platform,
            sd.agent_id,
            dc.publish_user_type,
            sd.resolve_status,
            sd.update_time,
            sd.subsys_code
           FROM (sys_domain sd
             LEFT JOIN sys_domain_check dc ON ((sd.id = dc.sys_domain_id)))) dm
  WHERE (dm.sys_domain_url IS NOT NULL);

COMMENT ON VIEW "v_domain_check" IS '域名审核视图--STEFFAN';