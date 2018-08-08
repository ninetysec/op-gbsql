-- auto gen by linsen 2018-07-26 17:55:00
-- 修复user_player表代理和总代信息 by laser
UPDATE user_player up SET user_agent_id = ua.id,agent_name = ua.username,general_agent_id = ut.id, general_agent_name = ut.username  FROM sys_user su, sys_user ua, sys_user ut
 WHERE su.user_type='24'
   AND ua.user_type='23'
   AND ut.user_type='22'
   AND su.owner_id = ua.id
   AND ua.owner_id = ut.id
   AND up.id = su.id;