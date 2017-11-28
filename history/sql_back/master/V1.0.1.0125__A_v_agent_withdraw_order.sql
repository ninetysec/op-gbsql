-- auto gen by cheery 2015-10-16 13:56:58
-- 添加遗漏的nation字段
DROP VIEW IF EXISTS v_agent_withdraw_order;

CREATE OR REPLACE VIEW "v_agent_withdraw_order" AS
  SELECT t3.username,
    t5.username AS auditname,
    t6.username AS agentname,
    t7.username AS parentagentname,
    t8.rank_name,
    t8.risk_marker,
    t3.region,
    t3.nation,
    t3.country,
    t3.city,
    t3.real_name,
    t3.create_time AS register_time,
    t3.status,
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
    t2.withdraw_count,
    t1.is_lock,
    t1.lock_person_id,
    t9.username AS lock_person_name
  FROM agent_withdraw_order t1
  LEFT JOIN user_agent t2 ON t1.agent_id = t2.id
  LEFT JOIN sys_user t3 ON t3.id = t2.id
  LEFT JOIN user_player t4 ON t4.id = t3.id
  LEFT JOIN sys_user t5 ON t5.id = t1.audit_user_id
  LEFT JOIN sys_user t6 ON t6.id = t4.user_agent_id
  LEFT JOIN sys_user t7 ON t7.id = t2.parent_id
  LEFT JOIN player_rank t8 ON t8.id = t4.rank_id
  LEFT JOIN sys_user t9 ON t9.id = t1.lock_person_id;

ALTER TABLE "v_agent_withdraw_order" OWNER TO "postgres";
COMMENT ON VIEW "v_agent_withdraw_order" IS '代理审核视图 -- orange';
