-- auto gen by cherry 2016-03-03 09:59:31
DROP view if EXISTS v_ctt_logo_user;
--修改LOGO提交人信息视图,去掉删除标识过滤字段
CREATE OR REPLACE VIEW "v_ctt_logo_user" AS
  SELECT a.id,
    a.name,
    a.start_time,
    a.end_time,
    a.create_user,
    a.create_time,
    a.update_user,
    a.update_time,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.publish_time
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.publish_time
        END AS publish_time,
    a.is_default,
    a.check_user_id,
    a.check_time,
    a.reason_title,
    a.reason_content,
    a.author,
    b.user_type,
    b.username,
    a.is_delete,
    a.check_parent_id,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.check_status
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.check_status
        END AS check_status,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) > 0) THEN ( SELECT l.path
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.path
        END AS path
   FROM (( SELECT l.id,
            l.name,
            l.path,
            l.start_time,
            l.end_time,
            l.create_user,
            l.create_time,
            l.update_user,
            l.update_time,
            l.publish_time,
            l.is_default,
            l.check_user_id,
            l.check_status,
            l.check_time,
            l.reason_title,
            l.reason_content,
            l.is_delete,
            l.check_parent_id,
            COALESCE(l.update_user, l.create_user) AS author
           FROM ctt_logo l) a
     LEFT JOIN sys_user b ON ((a.author = b.id)))
  WHERE (a.check_parent_id IS NULL);

COMMENT ON VIEW "v_ctt_logo_user" IS 'LOGO提交审核人信息--river';

DROP view if  EXISTS v_agent_fund_record;
--修改代理资金记录条件问题
CREATE OR REPLACE VIEW "v_agent_fund_record" AS
 SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
        CASE a.settlement_state
            WHEN 'pending_lssuing'::text THEN '1'::text
            WHEN 'lssuing'::text THEN '2'::text
            WHEN 'reject_lssuing'::text THEN '4'::text
            ELSE 'ONO'::text
        END AS status,
    1 AS type,
    a.period AS periods,
    a.start_time
   FROM (( SELECT o.id,
            o.agent_id,
            o.transaction_no,
            o.settlement_state,
            o.currency,
            o.rebate_amount,
            o.actual_amount,
            o.create_time,
            o.reason_title,
            o.reason_content,
            o.remark,
            o.user_id,
            o.username,
            o.rebate_bill_id,
            b_1.start_time,
            b_1.end_time,
            b_1.create_time AS bill_create_time,
            b_1.period
           FROM (agent_rebate_order o
             LEFT JOIN rebate_bill b_1 ON ((o.rebate_bill_id = b_1.id)))) a
     LEFT JOIN agent_water_bill b ON ((a.id = b.order_id)))
  WHERE ((a.settlement_state)::text = 'lssuing'::text)
UNION
 SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    ''::character varying AS periods,
    now() AS start_time
   FROM (agent_withdraw_order a
     LEFT JOIN agent_water_bill b ON (((a.id = b.order_id) AND (a.agent_id = b.agent_id))));
COMMENT ON VIEW "v_agent_fund_record" IS '代理资金账户流水--susu';

UPDATE sys_param SET default_value = '' WHERE param_type = 'privilage_pass_time' AND param_code = 'setting.privilage.pass.time';