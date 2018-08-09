-- auto gen by steffan 2018-07-31 10:18:44

UPDATE player_transaction pt SET agent_username =  ua.username, topagent_username = ut.username,topagent_id=ut.id
  FROM sys_user ua, sys_user ut
 WHERE ua.user_type='23'
   AND ut.user_type='22'
   AND pt.agent_id = ua.id
   AND ua.owner_id = ut.id
   AND ( pt.agent_username <> ua.username or pt.agent_username is null  OR pt.topagent_username <> ut.username or pt.topagent_username is null )
   AND pt.completion_time >= '2018-06-30 15:00:00' AND pt.completion_time <= '2018-07-15 15:00:00';