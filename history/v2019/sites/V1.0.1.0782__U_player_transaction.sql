-- auto gen by linsen 2018-04-24 14:23:48
-- 同步player_transaction表玩家代理线信息数据
UPDATE player_transaction pt
   SET user_name = ut.username, agent_id = ut.agent_id, agent_username = ut.agent_name,
       topagent_id = ut.topagent_id, topagent_username = ut.topagent_name
  FROM v_sys_user_tier ut
 WHERE pt.player_id = ut.id;