-- auto gen by cherry 2017-09-04 16:52:30
 select redo_sqls($$
    ALTER TABLE agent_withdraw_order ADD COLUMN remittance_way varchar(1);
		ALTER TABLE agent_withdraw_order ADD COLUMN bit_amount  numeric(20,8);
  $$);
COMMENT on COLUMN agent_withdraw_order.remittance_way is '打款方式:1-现金打款 2-比特币打款';
COMMENT on COLUMN agent_withdraw_order.bit_amount is '比特币金额';

DROP view IF EXISTS v_agent_withdraw_order;
ALTER TABLE agent_withdraw_order ALTER COLUMN agent_bankcard TYPE varchar(36);
CREATE OR REPLACE VIEW "v_agent_withdraw_order" AS
 SELECT agent.username,
    audi.username AS auditname,
    topagent.username AS topagentname,
    agent.region,
    agent.nation,
    agent.country,
    agent.city,
    agent.real_name,
    agent.create_time AS register_time,
    agent.status,
    t1.id,
    t1.audit_user_id,
    t1.agent_id,
    t1.transaction_no,
    t1.currency,
    t1.withdraw_amount,
    t1.actual_amount,
    t1.agent_bank,
    t1.agent_realname,
    t1.agent_bankcard,
    t1.create_time,
    t1.audit_time,
    t1.check_status,
    t1.audit_remark,
    t1.transaction_status,
    t1.reason_title,
    t1.reason_content,
    t1.remark,
    useragent.withdraw_count,
    t1.is_lock,
    t1.lock_person_id,
    t1.ip_withdraw,
    t1.ip_dict_code,
    lock.username AS lock_person_name
   FROM (((((agent_withdraw_order t1
     LEFT JOIN sys_user agent ON ((agent.id = t1.agent_id)))
     LEFT JOIN user_agent useragent ON ((useragent.id = t1.agent_id)))
     LEFT JOIN sys_user audi ON ((audi.id = t1.audit_user_id)))
     LEFT JOIN sys_user topagent ON ((topagent.id = agent.owner_id)))
     LEFT JOIN sys_user lock ON ((lock.id = t1.lock_person_id)));

COMMENT ON VIEW "v_agent_withdraw_order" IS '代理取款审核视图 -- orange';