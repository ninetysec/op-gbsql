-- auto gen by george 2017-11-20 11:50:14
DROP VIEW IF EXISTS v_sys_credit;

CREATE OR REPLACE VIEW "v_sys_credit" AS
 SELECT ss.id,
    su.owner_id center_id,
    ss.name site_name,
    ss.sys_user_id master_id,
    su.username master_name,
    (COALESCE(ss.max_profit, 0) + COALESCE(ss.credit_line,0)) as max_profit_limit,
    ss.has_use_profit,
    ss.max_profit,
    CAST(((COALESCE(ss.has_use_profit,0)/(COALESCE(ss.max_profit, 0.01) + COALESCE(ss.credit_line,0)))*100) as decimal(38, 2)) AS percent,


    (select sum(pay_amount) from credit_record cr where cr.status='2' AND pay_type IN ('1','2') AND cr.create_time>= (SELECT date_trunc(
		'month',
		timezone (timezone, now())
	) - REPLACE (timezone, 'GMT', '') :: INTERVAL FROM sys_site WHERE id=ss.id) AND cr.create_time<(SELECT date_trunc(
		'month',
		timezone (timezone, now() + '1mon')
	) - REPLACE (timezone, 'GMT', '') :: INTERVAL FROM sys_site WHERE id=ss.id) AND cr.site_id=ss.id) AS all_recharge,



    ss.credit_line,
		ss.profit_time,
    (CASE WHEN COALESCE(ss.max_profit, 0) + COALESCE(ss.credit_line,0) > COALESCE(ss.has_use_profit,0) THEN 0 ELSE 1 END) AS status
   FROM (sys_site ss
     LEFT JOIN sys_user su ON ((ss.sys_user_id = su.id)))
  WHERE ss.id>0
  ORDER BY ss.id;

COMMENT ON VIEW "v_sys_credit" IS 'CREDIT视图 add by kobe';