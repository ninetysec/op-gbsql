-- auto gen by steffan 2018-07-31 10:18:27
-- auto gen by steffan 2018-07-31 10:18:26

UPDATE player_game_order pgo SET agentusername =  ua.username, topagentusername = ut.username, topagentid = ut.id
  FROM sys_user ua, sys_user ut
 WHERE ua.user_type='23'
   AND ut.user_type='22'
   AND pgo.agentid = ua.id
   AND ua.owner_id = ut.id
   AND ( pgo.agentusername <> ua.username  or pgo.agentusername is null OR pgo.topagentusername <> ut.username  or pgo.topagentusername is null
   or topagentid <> ut.id or topagentid is null )
   AND pgo.payout_time >= '2018-07-20 15:00:00' ;