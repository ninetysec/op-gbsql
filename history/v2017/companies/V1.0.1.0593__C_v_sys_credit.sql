-- auto gen by linsen 2018-04-05 09:43:22
-- 修改买分管理视图
DROP VIEW IF EXISTS v_sys_credit;
CREATE OR REPLACE VIEW "v_sys_credit" AS
 SELECT ss.id,
    ss.parent_id AS center_id,
    ( SELECT si.value
           FROM site_i18n si
          WHERE ((si.site_id = ss.id) AND (si.locale = (ss.main_language)::bpchar) AND ((si.type)::text = 'site_name'::text) AND ((si.module)::text = 'setting'::text) AND ((si.key)::text = 'name'::text))
         LIMIT 1) AS site_name,
    ss.sys_user_id AS master_id,
    su.username AS master_name,
    (COALESCE(ssc.max_profit, (0)::numeric) + COALESCE(ssc.credit_line, (0)::numeric)) AS max_profit_limit,
    ssc.has_use_profit,
    ssc.max_profit,
        CASE
            WHEN ((COALESCE(ssc.max_profit, 0.01) + COALESCE(ssc.credit_line, (0)::numeric)) = (0)::numeric) THEN (0)::numeric
            ELSE (((COALESCE(ssc.has_use_profit, (0)::numeric) / (COALESCE(ssc.max_profit, 0.01) + COALESCE(ssc.credit_line, (0)::numeric))) * (100)::numeric))::numeric(38,2)
        END AS percent,
    ( SELECT (COALESCE(sum(cr.pay_amount), (0)::numeric))::numeric(20,2) AS "coalesce"
           FROM credit_record cr
          WHERE (((cr.status)::text = '2'::text) AND ((cr.pay_type)::text = ANY (ARRAY['1'::text, '4'::text])) AND (cr.create_time >= ( SELECT (date_trunc('month'::text, (now() + (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval)) - (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval)
                   FROM sys_site
                  WHERE (sys_site.id = ss.id))) AND (cr.create_time < ( SELECT (date_trunc('month'::text, ((now() + (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval) + '1 mon'::interval)) - (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval)
                   FROM sys_site
                  WHERE (sys_site.id = ss.id))) AND (cr.site_id = ss.id))) AS all_recharge,
    ssc.credit_line,
    ssc.transfer_line,
    ssc.profit_time,
        CASE
            WHEN ((COALESCE(ssc.max_profit, (0)::numeric) + COALESCE(ssc.credit_line, (0)::numeric)) <= COALESCE(ssc.has_use_profit, (0)::numeric)) THEN 1
            WHEN ((COALESCE(ssc.current_transfer_limit, (0)::numeric) + COALESCE(ssc.transfer_line, (0)::numeric)) <= COALESCE((COALESCE(ssc.transfer_out_sum, (0)::numeric) - COALESCE(ssc.transfer_into_sum, (0)::numeric)), (0)::numeric)) THEN 2
            ELSE 0
        END AS status,
        CASE
            WHEN ((ssc.authorize_end_time IS NULL) OR (ssc.authorize_end_time < now())) THEN true
            ELSE false
        END AS authorize_status,
    ssc.default_profit,
    ss.timezone,
    ssc.default_transfer_limit,
    (COALESCE(ssc.current_transfer_limit, (0)::numeric) + COALESCE(ssc.transfer_line, (0)::numeric)) AS current_transfer_limit,
    (COALESCE(ssc.transfer_out_sum, (0)::numeric) - COALESCE(ssc.transfer_into_sum, (0)::numeric)) AS transfer_sum,
        CASE
            WHEN ((COALESCE(ssc.current_transfer_limit, 0) + COALESCE(ssc.transfer_line, (0)::numeric)) = (0)::numeric) THEN (0)::numeric
            ELSE (((COALESCE((COALESCE(ssc.transfer_out_sum, (0)::numeric) - COALESCE(ssc.transfer_into_sum, (0)::numeric)), (0)::numeric) / (COALESCE(ssc.current_transfer_limit, 0) + COALESCE(ssc.transfer_line, (0)::numeric))) * (100)::numeric))::numeric(38,2)
        END AS transfer_percent,
    ds.idc
   FROM (((sys_site ss
     LEFT JOIN sys_user su ON ((ss.sys_user_id = su.id)))
     LEFT JOIN sys_site_credit ssc ON ((ss.id = ssc.id)))
     JOIN sys_datasource ds ON ((ss.id = ds.id)))
  WHERE ((ss.id > 0) AND ((ss.status)::text = '1'::text));
COMMENT ON VIEW "v_sys_credit" IS 'CREDIT视图 edit by kobe';