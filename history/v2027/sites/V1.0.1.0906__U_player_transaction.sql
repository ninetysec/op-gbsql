-- auto gen by linsen 2018-07-12 17:39:06
-- 修复2018.6.23到当前 player_transaction表导入玩家总代数据
UPDATE player_transaction pt
SET topagent_id = up.general_agent_id,
topagent_username = up.general_agent_name
FROM
	user_player up
WHERE
	pt.player_id = up.id
AND up.create_channel = '3'
AND pt.topagent_id != up.general_agent_id
AND pt.create_time>='2018-06-23 00:00:00';