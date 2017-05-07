-- auto gen by cheery 2015-11-24 01:52:30
COMMENT ON COLUMN "settlement_rebate_agent"."deduct_expenses" IS '分摊费用(原扣除费用)';

-- settlement_rebate_agent --
select redo_sqls($$
  ALTER TABLE settlement_rebate_agent ADD COLUMN refund_fee numeric(20,2) NULL;
  ALTER TABLE settlement_backwater_player ADD COLUMN agent_id INT4 NULL;
  ALTER TABLE settlement_backwater_player ADD COLUMN top_agent_id INT4 NULL;
$$);

COMMENT ON COLUMN settlement_rebate_agent.refund_fee IS '返手续费';

COMMENT ON COLUMN settlement_backwater_player.agent_id IS '代理ID';

COMMENT ON COLUMN settlement_backwater_player.top_agent_id IS '总代ID';

UPDATE sys_resource SET url = 'report/rebate/rebateIndex.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '返佣统计' AND parent_id = 5 AND subsys_code = 'mcenter');

UPDATE sys_resource SET url = 'report/rebate/agentRebate.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '返佣统计' AND parent_id = 33 AND subsys_code = 'mcenterAgent');

