-- auto gen by admin 2016-06-14 14:35:34
DROP view if EXISTS v_sys_domain_check;

CREATE OR REPLACE VIEW "v_sys_domain_check" AS

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

        END AS check_stauts_order

   FROM ( SELECT sd.name,

            sd.page_url,

            sd.domain AS sys_domain_url,

            dc.id,

            dc.site_id,

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

            dc.domain,

            dc.code,

            dc.site_name,

            dc.domain_platform,

            dc.agent_id,

            dc.publish_user_type

           FROM (sys_domain_check dc

             LEFT JOIN sys_domain sd ON ((dc.sys_domain_id = sd.id)))) dm

  WHERE (dm.sys_domain_url IS NOT NULL);

COMMENT ON VIEW "v_sys_domain_check" IS '域名审核视图--younger';


INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")

  SELECT 'common', 'status', 'cancel', '10', '状态:取消订单', NULL, 't'

  WHERE 'cancel' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');



INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")

  SELECT 'common', 'status', 'tosubmit', '11', '待提交', NULL, 't'

  WHERE 'tosubmit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');

