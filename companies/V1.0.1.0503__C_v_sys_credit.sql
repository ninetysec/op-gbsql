-- auto gen by george 2018-01-02 09:28:06
select redo_sqls($$
alter table sys_site add column authorize_end_time TIMESTAMP(6);
$$);
COMMENT ON COLUMN sys_site.authorize_end_time IS '授权截止时间';

DROP VIEW IF EXISTS v_sys_credit;
CREATE OR REPLACE VIEW "v_sys_credit" AS
 SELECT ss.id,
    su.owner_id AS center_id,
    ss.name AS site_name,
    ss.sys_user_id AS master_id,
    su.username AS master_name,
    (COALESCE(ss.max_profit, (0)::numeric) + COALESCE(ss.credit_line, (0)::numeric)) AS max_profit_limit,
    ss.has_use_profit,
    ss.max_profit,
    (((COALESCE(ss.has_use_profit, (0)::numeric) / (COALESCE(ss.max_profit, 0.01) + COALESCE(ss.credit_line, (0)::numeric))) * (100)::numeric))::numeric(38,2) AS percent,
    ( SELECT sum(cr.pay_amount) AS sum
           FROM credit_record cr
          WHERE (((cr.status)::text = '2'::text) AND ((cr.pay_type)::text = '1'::text) AND (cr.create_time >= ( SELECT (date_trunc('month'::text, timezone((sys_site.timezone)::text, now())) - (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval)
                   FROM sys_site
                  WHERE (sys_site.id = ss.id))) AND (cr.create_time < ( SELECT (date_trunc('month'::text, timezone((sys_site.timezone)::text, (now() + '1 mon'::interval))) - (replace((sys_site.timezone)::text, 'GMT'::text, ''::text))::interval)
                   FROM sys_site
                  WHERE (sys_site.id = ss.id))) AND (cr.site_id = ss.id))) AS all_recharge,
    ss.credit_line,
    ss.profit_time,
        CASE
            WHEN ((COALESCE(ss.max_profit, (0)::numeric) + COALESCE(ss.credit_line, (0)::numeric)) > COALESCE(ss.has_use_profit, (0)::numeric)) THEN 0
            ELSE 1
        END AS status,
				CASE
						WHEN ss.authorize_end_time IS NULL OR ss.authorize_end_time < now() THEN TRUE
						ELSE FALSE
				END AS authentication_status
   FROM (sys_site ss
     LEFT JOIN sys_user su ON ((ss.sys_user_id = su.id)))
  WHERE ((ss.id > 0) AND ((ss.status)::text = '1'::text))
  ORDER BY ((((COALESCE(ss.has_use_profit, (0)::numeric) / (COALESCE(ss.max_profit, 0.01) + COALESCE(ss.credit_line, (0)::numeric))) * (100)::numeric))::numeric(38,2)) DESC;


COMMENT ON VIEW "v_sys_credit" IS 'CREDIT视图 edit by leo';