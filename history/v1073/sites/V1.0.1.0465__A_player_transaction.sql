-- auto gen by cherry 2017-07-03 14:18:39
DROP VIEW IF EXISTS "v_player_transaction";
DROP VIEW IF EXISTS "v_player_funds_record";
DROP VIEW IF EXISTS "v_player_api_transaction";
DROP VIEW IF EXISTS v_preferential_recode;
ALTER TABLE player_transaction ALTER COLUMN transaction_data type varchar(1024);
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
   FROM ((((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN user_player up ON ((up.id = pt.player_id)))
     LEFT JOIN player_recharge pr ON ((pr.id = pt.source_id)))
     LEFT JOIN player_transfer pf ON ((pf.id = pt.source_id)));

COMMENT ON VIEW "v_player_transaction" IS '资金记录视图 By Faker';

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
   FROM ((((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN user_player up ON ((pt.player_id = up.id)))
     LEFT JOIN player_recharge pr ON ((pr.id = pt.source_id)))
     LEFT JOIN player_transfer pf ON ((pf.id = pt.source_id)));

COMMENT ON VIEW "v_player_funds_record" IS '新版资金记录视图--faker';

CREATE OR REPLACE VIEW "v_preferential_recode" AS
 SELECT apa.id,
    apa.user_id,
    apa.apply_time,
    apa.check_state,
    ami.activity_name,
    ami.activity_version,
    app.preferential_audit,
    app.preferential_value
   FROM ((activity_player_apply apa
     LEFT JOIN activity_message_i18n ami ON ((ami.activity_message_id = apa.activity_message_id)))
     LEFT JOIN activity_player_preferential app ON ((app.activity_player_apply_id = apa.id)))
UNION
 SELECT pf.id,
    pf.player_id AS user_id,
    pt.create_time AS apply_time,
    pt.status AS check_state,
    ((pt.transaction_data)::json ->> 'activityName'::text) AS activity_name,
    NULL::character varying AS activity_version,
    pf.audit_favorable_multiple AS preferential_audit,
    pf.favorable AS preferential_value
   FROM (player_favorable pf
     LEFT JOIN player_transaction pt ON ((pf.player_transaction_id = pt.id)))
  WHERE (((pt.transaction_way)::text = 'manual_favorable'::text) AND ((pt.fund_type)::text = 'artificial_deposit'::text));

COMMENT ON VIEW "v_preferential_recode" IS '优惠记录视图';

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
   FROM (((player_transfer pf
     LEFT JOIN sys_user su ON ((pf.user_id = su.id)))
     LEFT JOIN user_player up ON ((pf.user_id = up.id)))
     LEFT JOIN player_transaction pt ON (((pf.transaction_no)::text = (pt.transaction_no)::text)));

COMMENT ON VIEW "v_player_api_transaction" IS 'api转帐视图';