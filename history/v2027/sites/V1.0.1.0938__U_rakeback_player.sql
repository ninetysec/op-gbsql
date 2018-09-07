-- auto gen by steffan 2018-07-31 10:19:23

UPDATE rakeback_player rp SET agent_username =  ua.username, topagent_username = ut.username, top_agent_id = ut.id
  FROM rakeback_bill rb, sys_user ua, sys_user ut
 WHERE ua.user_type='23'
   AND ut.user_type='22'
   AND rp.agent_id = ua.id
   AND ua.owner_id = ut.id
   AND (rp.agent_username is null or  rp.topagent_username is null  or  rp.agent_username <> ua.username OR rp.topagent_username <> ut.username)
   AND rp.rakeback_bill_id = rb.id
   AND rb.start_time >= '2018-06-30 15:00:00';