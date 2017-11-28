-- auto gen by cheery 2015-12-10 08:46:14
UPDATE sys_resource SET url = 'topAgentAgent/list.html', remark = '总代管理-代理管理', sort_num = 2 WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '代理管理' AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET "name" = '总代首页' WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '总代理首页' AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET url = 'topagent/report/operate/operateIndex.html', remark = '统计报表-经营报表' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '经营报表' AND parent_id = 23 AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET url = 'agent/report/operate/operateIndex.html', remark = '统计报表-经营报表' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '经营报表' AND parent_id = 33 AND subsys_code = 'mcenterAgent');
UPDATE sys_resource SET url = 'topagent/report/occupy/reportIndex.html', remark = '统计报表-占成统计' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '占成统计' AND parent_id = 23 AND subsys_code = 'mcenterTopAgent');
  select redo_sqls($$
    ALTER TABLE operate_topagent ADD COLUMN top_agent_num integer NULL;
	ALTER TABLE operate_agent ADD COLUMN agent_num integer NULL;
  $$);

COMMENT ON COLUMN operate_topagent.top_agent_num IS '总代数量';
COMMENT ON COLUMN operate_agent.agent_num IS '代理数量';

-- 删除game_type_parent,新增api_type_id
ALTER TABLE operate_topagent DROP COLUMN IF EXISTS game_type_parent;
select redo_sqls($$
  ALTER TABLE operate_topagent ADD COLUMN api_type_id int4;
$$);

COMMENT ON COLUMN operate_topagent.api_type_id IS 'api_type表ID';
-- 删除game_type_parent,新增api_type_id
ALTER TABLE operate_agent DROP COLUMN IF EXISTS game_type_parent;

select redo_sqls($$
 ALTER TABLE operate_agent ADD COLUMN api_type_id int4;
  $$);
COMMENT ON COLUMN operate_agent.api_type_id IS 'api_type表ID';

-- 删除game_type_parent,新增api_type_id
ALTER TABLE operate_player DROP COLUMN IF EXISTS game_type_parent;

select redo_sqls($$
 ALTER TABLE operate_player
  ADD COLUMN api_type_id int4;
  $$);

COMMENT ON COLUMN operate_player.api_type_id IS 'api_type表ID';

DELETE FROM sys_resource WHERE "id" in (SELECT id FROM sys_resource WHERE parent_id = 22 AND ("name" = '代理列表页' OR "name" = '玩家列表页') AND subsys_code = 'mcenterTopAgent');

-- 删除已废除的总代经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_top_agent;
-- 删除已废除的代理经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_agent;
-- 删除已废除的玩家经营报表 2015-11-26 By Fly --
DROP TABLE IF EXISTS operating_report_players;

/* -------- 总代占成统计详细视图 -------- */

CREATE OR REPLACE VIEW v_occupy_agent AS
SELECT ob."id",
	 oa.agent_name,
	 oa.effective_transaction,
	 oa.profit_loss,
	 oa.rakeback,
	 oa.preferential_value,
	 oa.refund_fee,
	 oa.rebate,
	 oa.apportion,
	 oa.occupy_total,
	 ob.start_time,
	 ob.end_time,
	 ot.top_agent_id
FROM occupy_bill ob
LEFT JOIN occupy_agent oa ON ob."id" = oa.occupy_bill_id
LEFT JOIN occupy_topagent ot ON ob."id" = ot.occupy_bill_id;

ALTER TABLE v_occupy_agent OWNER TO postgres;
COMMENT ON VIEW v_occupy_agent IS '总代占成统计详细视图';