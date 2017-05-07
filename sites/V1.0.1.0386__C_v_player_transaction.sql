-- auto gen by cherry 2017-02-21 16:07:01
DROP VIEW if EXISTS v_player_transaction;
CREATE OR REPLACE VIEW "v_player_transaction" AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    su.username,
    su.user_type,
    up.agent_name AS agentname,
    up.user_agent_id AS agentid,
    up.general_agent_id AS topagentid,
    up.general_agent_name AS topagentusername,
    pr.is_first_recharge,
    pr.payer_bankcard,
    pr.recharge_total_amount,
    pr.recharge_amount,
    pr.recharge_address,
    pf.api_id,
    pt.origin,
    pt.rank_id
   FROM player_transaction pt
     LEFT JOIN sys_user su ON pt.player_id = su.id
		 LEFT JOIN user_player up ON up.id = pt.player_id
     LEFT JOIN player_recharge pr ON pr.id = pt.source_id
     LEFT JOIN player_transfer pf ON pf.id = pt.source_id;
COMMENT ON VIEW "v_player_transaction" IS '资金记录视图 By Faker';

DROP VIEW IF EXISTS v_player_api_transaction;
CREATE OR REPLACE VIEW "v_player_api_transaction" AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    su.username,
    su.user_type,
    up.agent_name AS agentname,
    up.user_agent_id AS agentid,
    up.general_agent_id AS topagentid,
    up.general_agent_name AS topagentusername,
    pf.api_id,
    pt.origin,
    pt.rank_id
   FROM player_transfer pf
     LEFT JOIN sys_user su ON pf.user_id = su.id
		 LEFT JOIN user_player up ON pf.user_id = up.id
     LEFT JOIN player_transaction pt ON pf.transaction_no = pt.transaction_no;

COMMENT ON VIEW "v_player_api_transaction" IS 'api转帐视图';

CREATE OR REPLACE VIEW "v_player_funds_record" AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    pt.origin,
    pt.rank_id,
    su.username,
    su.user_type,
    up.agent_name AS agentname,
    up.user_agent_id AS agentid,
    up.general_agent_id AS topagentid,
    up.general_agent_name AS topagentusername,
    pr.is_first_recharge,
    pr.payer_bankcard,
    pr.recharge_total_amount,
    pr.recharge_amount,
    pr.recharge_address,
    pf.api_id
   FROM player_transaction pt
     LEFT JOIN sys_user su ON pt.player_id = su.id
		 LEFT JOIN user_player up ON pt.player_id = up.id
     LEFT JOIN player_recharge pr ON pr.id = pt.source_id
     LEFT JOIN player_transfer pf ON pf.id = pt.source_id;

COMMENT ON VIEW "v_player_funds_record" IS '新版资金记录视图--faker';
