-- auto gen by cheery 2015-11-24 01:26:42
UPDATE sys_resource set url = 'setting/vsubAccount/list.html' where name = '系统账号' AND subsys_code = 'mcenter' AND url <> 'setting/vsubAccount/list.html';
UPDATE sys_resource set url = 'vPlayerTransaction/list.html' where name = '资金记录' AND subsys_code = 'mcenter' AND url <> 'vPlayerTransaction/list.html';
UPDATE sys_resource set url = 'fund/transaction/chart.html' where name = '资金记录' AND subsys_code = 'pcenter' AND url <> 'fund/transaction/chart.html';
UPDATE sys_resource set url = 'fund/vAgentWithdrawOrder/agentList.html' where name = '代理取款审核' AND subsys_code = 'mcenter' AND url <> 'fund/vAgentWithdrawOrder/agentList.html';

drop VIEW if exists v_player_transaction ;
ALTER TABLE "player_transaction"
ALTER COLUMN "transaction_data" TYPE varchar(128) COLLATE "default";
CREATE or REPLACE VIEW v_player_transaction AS
  SELECT
    pt.id,
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
    su.username
  from player_transaction pt LEFT JOIN sys_user su on pt.player_id = su.id;
COMMENT ON VIEW "v_player_transaction" IS '玩家交易视图-jeff';
