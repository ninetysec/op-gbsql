-- auto gen by cheery 2015-12-27 09:21:48
drop table IF EXISTS ctt_carousel_language;

drop view IF EXISTS v_ctt_domain;

drop view IF EXISTS v_ctt_domain_rank;

drop view IF EXISTS v_ctt_draft;

DROP view IF EXISTS v_player_transaction;

drop table IF EXISTS ctt_domain;

drop table IF EXISTS ctt_domain_type;

drop table IF EXISTS ctt_draft;

--修改玩家交易视图
CREATE view v_player_transaction
AS
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
		agentuser.username agentname,
		agentuser.id agentid,
		topagentuser."id" topagentid,
		topagentuser.username topagentusername
   FROM (((player_transaction pt
     LEFT JOIN sys_user su ON (pt.player_id = su.id))
		LEFT JOIN sys_user agentuser ON (su.owner_id = agentuser."id"))
		LEFT JOIN sys_user topagentuser ON (agentuser.owner_id = topagentuser."id"));

COMMENT ON VIEW v_player_transaction IS '玩家交易视图--catban';