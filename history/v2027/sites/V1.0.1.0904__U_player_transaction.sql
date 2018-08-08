-- auto gen by linsen 2018-07-12 17:38:10
-- 修复2018.4.23到2018.5.23 player_transaction表导入玩家总代数据
UPDATE player_transaction pt
SET topagent_id = up.general_agent_id,
topagent_username = up.general_agent_name
FROM
	user_player up
WHERE
	pt.player_id = up.id
AND up.create_channel = '3'
AND pt.topagent_id != up.general_agent_id
AND pt.create_time>='2018-04-23 00:00:00'
AND pt.create_time<'2018-05-23 00:00:00';